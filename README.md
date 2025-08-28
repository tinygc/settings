# Settings Repository

This repository contains Claude Code configuration and development guidelines.

## Files

- `CLAUDE.md` - Claude Code development guidelines and project settings
- `VSCode/` - VSCode configuration files
  - `settings.json` - VSCode user settings with extensive command auto-approval configurations
- `ClaudeCode/` - Claude Code configuration files
  - `settings.json` - Claude Code permissions settings with allow/ask lists for secure command execution
- `notify.ps1` - Windows Toast notification script

## Installation & Configuration

### VSCode Settings

**配置場所**: `~/.config/Code/User/settings.json` (Linux) または `%APPDATA%\Code\User\settings.json` (Windows)

```bash
# Linux/macOS
cp VSCode/settings.json ~/.config/Code/User/settings.json

# Windows
copy VSCode\settings.json %APPDATA%\Code\User\settings.json
```

**機能**:
- VS Code 1.103対応のAutoApprove設定
- 737行→193行に最適化（74%削減）
- ファイル操作、Git、Android開発等のカテゴリ別設定
- 安全性を確保した危険コマンドの明示的拒否

### Claude Code Settings

**配置場所**: `~/.claude/settings.json`

```bash
# 設定ファイルをコピー
cp ClaudeCode/settings.json ~/.claude/settings.json

# バックアップを作成する場合
cp ~/.claude/settings.json ~/.claude/settings.json.backup
```

**機能**:
- VSCode設定と連携したallow/askリスト
- 安全なコマンドは自動実行、危険なコマンドは確認必須
- MCP Servers設定も含む
- Android開発（ADB）、Git、パッケージ管理等をカバー

### Windows通知システム

**配置場所**: プロジェクトルート（`notify.ps1`）

```bash
# 使用例
powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "タスクが完了しました！" -Title "Claude Code" -Type "Information"
```

## 設定の同期方法

1. **VSCode設定を変更した場合**:
```bash
# VSCode設定をリポジトリにコピー
cp ~/.config/Code/User/settings.json VSCode/settings.json
```

2. **Claude設定を変更した場合**:
```bash
# Claude設定をリポジトリにコピー  
cp ~/.claude/settings.json ClaudeCode/settings.json
```

3. **設定をGitにコミット**:
```bash
git add .
git commit -m "Update configuration settings"
git push
```

## セキュリティ考慮事項

- **Allow List**: 安全で頻繁に使用するコマンドを自動承認
- **Ask List**: システムに影響を与える可能性があるコマンドは確認必須
- 設定の変更は必ずテストを実施してから適用すること
- バックアップファイルを定期的に作成すること

## Usage

This repository serves as the central configuration for Claude Code development workflows and project standards.