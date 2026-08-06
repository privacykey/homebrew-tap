cask "privacycommand" do
  # Bumped on every release: privacycommand's release CI updates
  # version/sha256 and opens a PR against this tap for a human to
  # review and merge. See README "How updates land here".
  version "0.1.5"
  sha256 "aadfc8157741e99169c854ce9dfe9f25f6be391a4d425e5b859fbed7697961cf"

  url "https://github.com/privacykey/privacycommand/releases/download/v#{version}/privacycommand-#{version}.dmg"
  name "privacycommand"
  desc "Inspect app bundles for privacy and security findings"
  homepage "https://github.com/privacykey/privacycommand"

  # Sparkle's appcast lives on gh-pages. Linking it here gives Cask
  # users a sanity check that the version they're installing matches
  # what the in-app updater would otherwise pull.
  livecheck do
    url "https://privacykey.github.io/privacycommand/appcast.xml"
    strategy :sparkle
  end

  depends_on :macos

  app "privacycommand.app"

  # We're not sandboxed, so quitting the app is enough — no need for
  # a tighter `quit:` predicate. Suppress the in-app Sparkle updater
  # for Cask installs by setting the env var Sparkle reads to
  # detect this scenario; the UpdateController also covers the same
  # case via HomebrewDetector.
  zap trash: [
    "~/Library/Application Support/privacycommand",
    "~/Library/Caches/org.privacykey.privacycommand",
    "~/Library/Preferences/org.privacykey.privacycommand.plist",
    "~/Library/Saved Application State/org.privacykey.privacycommand.savedState",
  ]
end
