cask "privacytracker" do
  arch arm: "aarch64", intel: "x64"

  version "0.1.1"
  sha256 arm:   "9ff9ce0a12e70669286a7054d4a44d553697f517f442a2c48534e42e5b9c1788",
         intel: "6f921c408fcfa3a42a63ee446215a1a73f58c15b65bbee87fce10a5a60e3322c"

  url "https://github.com/privacykey/privacytracker/releases/download/v#{version}/privacytracker_#{version}_#{arch}.dmg",
      verified: "github.com/privacykey/privacytracker/"
  name "privacytracker"
  desc "Monitor, track, and get alerted when iOS apps change their privacy labels"
  homepage "https://github.com/privacykey/privacytracker"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "privacytracker.app"

  zap trash: [
    "~/Library/Application Support/privacytracker",
    "~/Library/Caches/org.privacykey.privacytracker",
    "~/Library/HTTPStorages/org.privacykey.privacytracker",
    "~/Library/HTTPStorages/org.privacykey.privacytracker.binarycookies",
    "~/Library/Preferences/org.privacykey.privacytracker.plist",
    "~/Library/Saved Application State/org.privacykey.privacytracker.savedState",
    "~/Library/WebKit/org.privacykey.privacytracker",
  ]
end
