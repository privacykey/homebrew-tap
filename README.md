# privacykey/homebrew-tap

Homebrew tap for [privacykey](https://github.com/privacykey) macOS apps and tools.

[![Project status](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fprivacykey%2F.github%2Fmain%2Fbadges%2Fhomebrew-tap.json)](https://github.com/privacykey/.github/blob/main/STATUS.md#homebrew-tap) [![Licence](https://img.shields.io/github/license/privacykey/homebrew-tap?label=licence)](LICENSE)

<!-- disclosure:start -->
> [!WARNING]
> **Project status.** The badge above is generated from [the privacykey status list](https://github.com/privacykey/.github/blob/main/STATUS.md), which says what I promise for this project and every other one.
<!-- disclosure:end -->

---

## What this tap serves

Three packages, each owned by the repository that builds it. This repo holds
only the cask and formula definitions — no build logic, no source.

| Package | Kind | What it is | Built by |
| --- | --- | --- | --- |
| [`privacycommand`](Casks/privacycommand.rb) | Cask | Inspect app bundles for privacy and security findings | [privacykey/privacycommand](https://github.com/privacykey/privacycommand) |
| [`privacytracker`](Casks/privacytracker.rb) | Cask | Monitor, track, and get alerted when iOS apps change their privacy labels | [privacykey/privacytracker](https://github.com/privacykey/privacytracker) |
| [`mantis`](Formula/mantis.rb) | Formula | Command-line client for Mantis — manage keys and watch hits from the terminal | [privacykey/mantis](https://github.com/privacykey/mantis) |

Both casks install a macOS `.app`; `privacytracker` requires Big Sur or newer.
The `mantis` formula ships darwin and linux builds for arm64 and x64, so it
installs on Linuxbrew as well.

## Installing from the tap

```sh
brew tap privacykey/tap

brew install --cask privacykey/tap/privacycommand
brew install --cask privacykey/tap/privacytracker
brew install privacykey/tap/mantis
```

The fully-qualified names work without tapping first, and stay unambiguous if a
package of the same name ever appears in homebrew/core or homebrew/cask.

Upgrading is ordinary Homebrew:

```sh
brew update
brew upgrade
```

To remove a package and the tap:

```sh
brew uninstall --cask privacycommand
brew untap privacykey/tap
```

## The version contract

This repository has no releases and no tags — there is no tap version to pin
against. `brew tap` tracks the default branch, so whatever is on `main` is what
every tap user resolves on their next `brew update`.

Versions are per-package instead: each file pins an exact `version` and
`sha256` against a release asset in the app's own repository. A `livecheck`
block in each package tells `brew livecheck` where upstream truth lives —
GitHub releases for `privacytracker` and `mantis`, the Sparkle appcast for
`privacycommand`.

If you need to hold a version, `brew pin mantis` freezes the installed formula
against `brew upgrade`. Casks have no equivalent; skip them by name instead.

## How a release lands here

Nothing is pushed to `main` directly, and this repo has no dispatch receiver —
the only workflow it contains is the PR check. Bumps arrive as pull requests:

1. An app repo publishes a release
   ([privacytracker](https://github.com/privacykey/privacytracker/blob/main/.github/workflows/macos-release.yml),
   [mantis](https://github.com/privacykey/mantis/blob/main/.github/workflows/cli-release.yml),
   [privacycommand](https://github.com/privacykey/privacycommand/blob/main/.github/workflows/release.yml),
   which delegates to the shared
   [macos-sparkle-release](https://github.com/privacykey/gh-workflows/blob/main/.github/workflows/macos-sparkle-release.yml)).
2. Its release workflow renders this tap's cask or formula with the new
   `version` and `sha256`, pushes a branch here, and opens a PR against `main`.
   It authenticates with a `HOMEBREW_TAP_TOKEN` repo secret: a fine-grained
   personal access token scoped to **this repository only**, with Contents and
   Pull requests read & write. The workflows' default `GITHUB_TOKEN` cannot
   reach this repo at all.
3. The [PR checks workflow](.github/workflows/pr-checks.yml) runs a Ruby syntax
   check and `brew style` over `Casks/` and `Formula/`.
4. A maintainer reviews and merges. Merging is what publishes the update.

## Changing anything here safely

All three files are generated upstream, not authored here. Two of them say so
in a header comment; `Casks/privacycommand.rb` does not, but it is rendered
from `packaging/homebrew/privacycommand.rb` in the privacycommand repo just the
same. Edit the template in the app repo — a hand-edit here survives only until
that project's next release overwrites it.

The blast radius of a bad merge is every tap user: a file that fails to parse
breaks `brew update` for anyone who has this tap installed, not just the people
who installed that one package. Run the same checks CI runs before you open a
PR:

```sh
just lint          # ruby -c over both directories, then brew style
```

Long stretches with no commits are the intended state. Three packages that all
match their upstream releases and a tap nobody has needed to touch is a healthy
tap, not an abandoned one.

## Licence

[MIT](LICENSE)
