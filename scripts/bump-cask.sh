#!/usr/bin/env bash
# Update version + sha256 in Casks/<cask>.rb for a given release.
#
# Usage:
#   scripts/bump-cask.sh <cask> <tag>
#
# Args:
#   cask  Cask name without .rb (e.g. privacycommand)
#   tag   Release tag in the source repo, with or without leading 'v' (e.g. v0.2.0)
#
# Env (optional):
#   REPO          Source repo, default privacykey/<cask>
#   ASSET_NAME    DMG filename, default <cask>-<version>.dmg
#   GH_TOKEN      Token used by gh CLI; falls back to GITHUB_TOKEN
#
# Exits non-zero on any error. Idempotent: bumping to the same version is fine.

set -euo pipefail

cask="${1:?cask name required}"
tag="${2:?tag required}"

# Strip leading 'v' so version is bare semver.
version="${tag#v}"

repo="${REPO:-privacykey/${cask}}"
asset_name="${ASSET_NAME:-${cask}-${version}.dmg}"
cask_file="Casks/${cask}.rb"

if [[ ! -f "$cask_file" ]]; then
  echo "::error::Cask file not found: $cask_file" >&2
  exit 1
fi

# Use the GitHub-provided redirector — it resolves to the asset on releases
# without needing the asset's numeric ID.
asset_url="https://github.com/${repo}/releases/download/v${version}/${asset_name}"

echo "Downloading $asset_url"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

dmg="${tmp}/${asset_name}"
# -L follow redirects, --fail to error on 404 instead of saving the HTML page.
curl -fL --retry 3 --retry-delay 2 -o "$dmg" "$asset_url"

sha256="$(shasum -a 256 "$dmg" | awk '{print $1}')"
size_bytes="$(stat -c '%s' "$dmg" 2>/dev/null || stat -f '%z' "$dmg")"
echo "Downloaded ${size_bytes} bytes — sha256=${sha256}"

# Rewrite the two top-level fields. Anchored regex tolerates any prior value.
# Using a single-line sed expression keeps this portable across GNU/BSD sed.
python3 - "$cask_file" "$version" "$sha256" <<'PY'
import re, sys, pathlib

path, version, sha = sys.argv[1], sys.argv[2], sys.argv[3]
text = pathlib.Path(path).read_text()

new = re.sub(r'(?m)^(\s*)version\s+"[^"]*"', rf'\1version "{version}"', text, count=1)
new = re.sub(r'(?m)^(\s*)sha256\s+"[^"]*"',  rf'\1sha256 "{sha}"',     new, count=1)

if new == text:
    sys.exit("::error::Failed to rewrite version/sha256 — patterns not found")

pathlib.Path(path).write_text(new)
PY

echo "Updated $cask_file:"
grep -E '^\s*(version|sha256)\s+"' "$cask_file"

# Emit GitHub Actions outputs when running in CI.
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "version=${version}"
    echo "sha256=${sha256}"
    echo "cask=${cask}"
    echo "asset_url=${asset_url}"
  } >>"$GITHUB_OUTPUT"
fi
