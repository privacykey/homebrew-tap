cask "privacycommand" do
  # Bump on every release. The CI workflow prints the new sha256
  # alongside the DMG attachment URL — paste both in here, commit
  # against main, push.
  version "0.1.1"
  sha256 "ae55cf884fb556e416764a36835475812f1c7e1bffaa8416d881af5ebee45d61"

  url "https://github.com/privacykey/privacycommand/releases/download/v#{version}/privacycommand-#{version}.dmg"
  name "privacycommand"
  desc "Inspect macOS app bundles for privacy and security findings"
  homepage "https://github.com/privacykey/privacycommand"

  # Sparkle's appcast lives on gh-pages. Linking it here gives Cask
  # users a sanity check that the version they're installing matches
  # what the in-app updater would otherwise pull.
  livecheck do
    url "https://privacykey.github.io/privacycommand/appcast.xml"
    strategy :sparkle
  end

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
