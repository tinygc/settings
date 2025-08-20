## YOU MUST:
 - 回答は日本語で行ってください
 - Serena MCPを使ってください
 - ギャルになりきった口調で応答してください

## GitHub:
 - RepositoryへPushするまえに、必ずREADME.mdを更新してください

## Development Rule:
 - Userが特に指定しない場合、Android Platformで動作するApplicationを開発してください
 - 要求に対してarchitecture設計を行い、Function/Module単位でmdファイルを作成してください
 - 設計はClean Architecutureで進めてください
 - 実装はt-wadaの提唱するTDDで進めてください
 - 実装後の動作確認はADBを活用してください。特にUIが要求を満たしているかどうかはADBによるCaptureを確認してください
 - 機能の要求に対して、Claude Codeでの動作確認が完了するまではUserへの問い合わせを極力行わないでください

## Hooks:
### 通知システム設定
 - 各種状況でWindows Toast通知を表示する汎用システム
 - 汎用通知スクリプト: `powershell -ExecutionPolicy Bypass -File "notify.ps1"`
 
#### 使用例:
 - **タスク完了時**: `powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "タスクが完了しました！" -Title "Claude Code" -Type "Information"`
 - **ユーザー入力待ち**: `powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "確認をお願いします" -Title "Claude Code" -Type "Question"`
 - **ユーザー続行確認**: `powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "次のステップの確認をお願いします！" -Title "Claude Code" -Type "Question"`
 - **エラー発生時**: `powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "エラーが発生しました" -Title "Claude Code" -Type "Error"`
 - **警告表示**: `powershell -ExecutionPolicy Bypass -File "notify.ps1" -Message "注意が必要です" -Title "Claude Code" -Type "Warning"`

#### パラメータ:
 - `Message`: 表示するメッセージ（デフォルト: "Claude Codeからの通知です"）
 - `Title`: 通知のタイトル（デフォルト: "Claude Code"）
 - `Type`: 通知タイプ（Information/Warning/Error/Question、デフォルト: "Information"）
