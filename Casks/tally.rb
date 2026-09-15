cask "tally" do
  version "1.0.0"
  sha256 "18e62b9c51594366cda3d284df15c7331a3084ba3ffe9ee7c48d6bcbfe0957f9"

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
