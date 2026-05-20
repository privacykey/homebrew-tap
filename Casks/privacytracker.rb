cask "privacytracker" do
  arch arm: "aarch64", intel: "x64"

  version "0.1.0"
  sha256 arm:   "2b90d5382b659cd517d26345971a018dba4690dbbc33dd4ab703989baa01c508",
         intel: "4a444f606bd73736598be572331e7f89e41c2435b24427735389b6f48bd496ec"

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
