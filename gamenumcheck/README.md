# 数字あてゲーム (Game Number Check)

Android向けの数字あてゲームアプリです。Clean ArchitectureとTDDで実装されています。

## 🎯 概要

1〜100の数字を当てるゲームアプリです。段階的なヒント機能と達成システムで楽しい体験を提供します。

## ✨ 主な機能

- **数字当てゲーム**: 1〜100の数字をランダム生成して当てる
- **段階的ヒントシステム**: 挑戦回数に応じて詳細になるヒント
- **達成バッジシステム**: 挑戦回数に応じた6段階の称号
- **美しいUI**: Material Design 3とJetpack Composeで実装
- **アニメーション**: 正解時の祝福演出と滑らかなUI遷移

## 🏗️ アーキテクチャ

Clean Architectureの3層構造で実装：

```
├── presentation/     # UI層
│   ├── screen/      # 画面コンポーネント
│   ├── component/   # 共通UIコンポーネント  
│   └── viewmodel/   # ViewModel層
├── domain/          # ドメイン層
│   ├── model/       # エンティティ
│   ├── usecase/     # ユースケース
│   └── repository/  # リポジトリインターフェース
└── data/           # データ層
    ├── repository/  # リポジトリ実装
    └── datasource/ # データソース
```

## 🛠️ 技術スタック

- **言語**: Kotlin
- **UIフレームワーク**: Jetpack Compose
- **アーキテクチャ**: Clean Architecture + MVVM
- **DI**: Dagger Hilt
- **非同期処理**: Coroutines & Flow
- **テスト**: JUnit, MockK, Turbine
- **開発手法**: TDD (Test-Driven Development)

## 🎮 ゲーム仕様

### ルール
- 対象範囲: 1〜100の数字
- 入力方式: テンキー風UI
- 制限: なし（時間・回数制限なし）

### ヒントシステム
- **1-3回目**: 「もっと大きい！」「もっと小さい！」
- **4-6回目**: 「かなり大きい！」「ちょっと小さい！」  
- **7-9回目**: 「あと少し！」「もうちょっと！」
- **10回目以降**: 「惜しい！○○に近いよ！」

### 達成システム
| 挑戦回数 | 称号 | 説明 |
|---------|------|------|
| 1回 | 🌟超能力者！ | 一発で当てるなんて神すぎ！ |
| 2-3回 | 🎯天才！ | めっちゃすごい直感力！ |
| 4-5回 | ✨すごい！ | センス抜群だね！ |
| 6-7回 | 👍やったね！ | よく頑張った！ |
| 8-10回 | 🌱がんばったね！ | 諦めない心が素敵！ |
| 11回以上 | 💪ファイト！ | 次こそは！応援してるよ！ |

## 📱 動作環境

- **最低動作環境**: Android 7.0 (API Level 24)
- **推奨環境**: Android 10.0 (API Level 29) 以上
- **対象SDK**: API 36

## 🚀 セットアップ

1. リポジトリをクローン
```bash
git clone https://github.com/tinygc/gamenumcheck.git
```

2. Android Studioで開く

3. Java環境設定（必要に応じて）
```bash
export JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
```

4. プロジェクトをビルド
```bash
./gradlew clean
./gradlew build
```

5. デバイス/エミュレーターで実行
```bash
./gradlew installDebug
```

### ⚠️ トラブルシューティング

#### Gradle kaptプラグインエラーが発生した場合
```
Error resolving plugin [id: 'org.jetbrains.kotlin.kapt', version: '2.0.21']
```

**解決方法**: トップレベルの`build.gradle.kts`にプラグインを追加済みです：
```kotlin
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
    alias(libs.plugins.kotlin.compose) apply false
    alias(libs.plugins.hilt) apply false
    alias(libs.plugins.kotlin.kapt) apply false
}
```

この設定により、Gradleビルドエラーは解決済みです。

## 🧪 テスト実行

```bash
# ユニットテスト実行
./gradlew test

# UIテスト実行  
./gradlew connectedAndroidTest
```

### ✅ ビルド状況
- **ユニットテスト**: ✅ 全6テストケース実行成功
- **デバッグビルド**: ✅ APK生成成功
- **GetHintUseCase**: ✅ すべてのヒント生成パターン検証済み

## 🔔 開発者通知システム

プロジェクトには汎用的なWindows通知システムが組み込まれています：

### 通知スクリプト
- **汎用通知**: `notify.ps1` - メッセージ、タイトル、タイプを指定可能
- **レガシー**: `notify-completion.ps1` - タスク完了専用（互換性維持）

### 使用例
```powershell
# タスク完了通知
powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "Task completed!" -Type "Information"

# ユーザー入力待ち
powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "Please confirm" -Type "Question"

# エラー通知
powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "Error occurred" -Type "Error"
```

## 📁 主要ファイル

### Domain層
- `Game.kt` - ゲームエンティティ
- `HintMessage.kt` - ヒントメッセージ
- `Achievement.kt` - 達成バッジ
- `GetHintUseCase.kt` - ヒント生成ロジック
- `CalculateAchievementUseCase.kt` - 達成判定ロジック

### Presentation層
- `GameScreen.kt` - メインゲーム画面
- `GameViewModel.kt` - ゲーム状態管理
- `NumberKeypad.kt` - テンキーコンポーネント
- `HintDisplay.kt` - ヒント表示
- `AchievementBadge.kt` - 達成バッジ表示

### Data層
- `GameRepositoryImpl.kt` - ゲームリポジトリ実装
- `RandomNumberRepositoryImpl.kt` - 乱数生成実装
- `InMemoryGameDataSource.kt` - インメモリデータソース

## 📄 ライセンス

MIT License - 詳細は[LICENSE](LICENSE)ファイルを参照

## 🤝 コントリビューション

プルリクエストやIssueを歓迎します！

---

*Clean Architecture + TDD + Jetpack Composeで実装された数字あてゲーム*