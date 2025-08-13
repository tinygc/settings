# Windows Toast Notification for Claude Code completion
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Simple notification using msg command (works on all Windows versions)
Start-Process -FilePath "msg" -ArgumentList "$env:USERNAME", "🎉 Claude Code タスク完了！ ゲームアプリの実装が完了したよ〜💖"

# Alternative: PowerShell balloon notification
$notification = New-Object System.Windows.Forms.NotifyIcon
$notification.Icon = [System.Drawing.SystemIcons]::Information
$notification.BalloonTipTitle = "Claude Code 完了通知"
$notification.BalloonTipText = "🎉 数字あてゲームアプリの実装が完了したよ〜！お疲れ様💖"
$notification.BalloonTipIcon = "Info"
$notification.Visible = $true
$notification.ShowBalloonTip(5000)

# Clean up after 6 seconds
Start-Sleep -Seconds 6
$notification.Dispose()

Write-Host "🎉 タスク完了通知を表示しました！"