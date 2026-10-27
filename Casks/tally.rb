cask "tally" do
  version "1.0.6"
  sha256 "12e8a07a8821bc5f6760d991fdcaf8cf738575e63f93a7adefd54a95466d9de4"

  url "https://github.com/guokuaile/tally/releases/download/v#{version}/Tally.dmg"
  name "Tally"
  desc "Claude Code and Codex session status and AI quotas in the MacBook notch"
  homepage "https://github.com/guokuaile/tally"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Tally.app"

  # The DMG is ad-hoc signed and not notarized; without this every install and upgrade needs "Open Anyway".
  postflight_steps do
    if_path_exists "{{appdir}}/Tally.app" do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Tally.app"]
    end
  end

  uninstall quit: "com.aiden.tally"

  # The login item lives in zap, not uninstall: upgrades run uninstall too and would remove it every time.
  zap launchctl: "com.aiden.tally.launch",
      trash:     "~/Library/Application Support/Tally"

  caveats <<~CAVEATS
    Before uninstalling, open Tally Settings > hook and click 移除 (Remove) on both rows,
    so ~/.claude/settings.json and ~/.codex/hooks.json stop pointing at Tally.
  CAVEATS
end
