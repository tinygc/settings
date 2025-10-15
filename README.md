# 設定リポジトリ

このリポジトリにはClaude CodeとVSCodeの設定、および開発ガイドラインが含まれています✨

## 📁 Files

- `AGENTS.md` - AI開発エージェント向けの統一ガイドライン（Claude Code、GitHub Copilot等）
- `ClaudeCode/` - Claude Code設定ファイル
  - `settings.json` - 安全なコマンド実行のためのallow/askリストを含む権限設定
- `VSCode/` - VSCode設定ファイル
  - `settings.json` - 包括的なコマンド自動承認設定を含むVSCodeユーザー設定

## 🎯 開発スタイル

### 基本方針
- **ターゲット**: Android TV向けApplication（特に指定がない場合）
- **開発モデル**: V字開発を基本とする
- **ドキュメント**: Markdownで作成
- **レビュー**: 各工程完了時にベテランエンジニア視点でレビュー実施
- **品質管理**: 重大な指摘事項がなくなるまで修正とレビューを繰り返し
- **タスク管理**: 各要件・タスクをGitHub Issuesとして登録し、Issue DrivenでTest完了まで管理
- **自走開発**: 設計着手後は要件定義に対するTestが完了するまで自走

### 開発フロー
1. **要件定義** → `requirement/`
   - ユーザー要求の詳細ヒアリング
   - ユーザーの完了宣言まで設計着手禁止

2. **設計** → `design/`
   - Architecture設計実施
   - Function/Module単位でドキュメント作成
   - Clean Architecture採用（Unity開発時はMVP4U）

3. **実装**
   - t-wadaのTDD（テスト駆動開発）で実装
   - Function/Module完了時にベテランエンジニア視点レビュー

4. **テスト** → `test/`
   - 要件充足性をTestで検証
   - Test結果をドキュメント出力
   - Windows: スクリーンキャプチャ
   - Android: ADBキャプチャ
   - Android TV: リモコン操作をADB実施、1コマンド毎にキャプチャ

## 🤖 Claude設定

- **応答言語**: 日本語のみ
- **応答スタイル**: ギャル口調
- **必須MCP**: Serena MCP使用

## インストール・設定方法

### VSCode設定

**配置場所**: `~/.config/Code/User/settings.json` (Linux) または `%APPDATA%\Code\User\settings.json` (Windows)

```bash
# Linux/macOS
cp VSCode/settings.json ~/.config/Code/User/settings.json

# Windows
copy VSCode\settings.json %APPDATA%\Code\User\settings.json
```

**機能**:
- VS Code 1.103対応のAutoApprove設定
- ターミナルコマンドのタイムアウト・並行実行制御
- GitHub Copilot連携設定
- ファイル操作、Git、Android開発等のカテゴリ別設定
- 安全性を確保した危険コマンドの明示的拒否

### Claude Code設定

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

### AI開発エージェント設定

**配置場所**: `AGENTS.md`

Claude Code、GitHub Copilot等のAI開発エージェント向けの統一ガイドライン。開発スタイル、GitHub設定、V字開発フローなどを定義しています。

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

3. **AI開発エージェント設定を変更した場合**:
```bash
# AGENTS.mdを直接編集
vim AGENTS.md
```

4. **設定をGitにコミット**:
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

## 📊 設定詳細

### ClaudeCode設定の特徴
- **Serena MCP**: セマンティックコーディングツールとメモリファイルを含む高度なコーディングエージェント
- **Screenshot MCP**: スクリーンキャプチャ機能（Android TV開発用）
- **Allow/Ask リスト**: 107の許可コマンド + 58の確認要求コマンド
- **セキュリティ**: 危険コマンドの明示的拒否設定
- **MCP Servers**: screenshot MCPサーバー設定を含む

### GitHub設定
- **アカウント**: https://github.com/TE-TakashiAMori
- **メールアドレス**: takashi.a.mori@sony.com
- **Push前チェック**: README.md更新必須

## 🚀 使用方法

このリポジトリはClaude Code開発ワークフローとプロジェクト標準の中央設定として機能します。

### 開発開始手順
1. 設定ファイルを適切な場所にコピー
2. AGENTS.mdの開発ガイドラインに従ってプロジェクト開始
3. Issue Driven開発でタスク管理
4. V字開発モデルに沿って進行
5. TDD + Clean Architectureで実装
6. 各工程でベテランエンジニア視点レビュー実施

すべての開発プロジェクトでこの設定を活用し、高品質なソフトウェア開発を実現しましょう〜💫