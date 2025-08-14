param(
    [string]$Message = "Claude Code notification",
    [string]$Title = "Claude Code",
    [string]$Type = "Information"
)

try {
    # Windows標準のballoon tip通知を使用
    Add-Type -AssemblyName System.Windows.Forms
    
    # NotifyIconオブジェクトを作成
    $notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.SystemIcons]::Information
    
    $notification.BalloonTipIcon = switch ($Type) {
        "Information" { [System.Windows.Forms.ToolTipIcon]::Info }
        "Warning" { [System.Windows.Forms.ToolTipIcon]::Warning }
        "Error" { [System.Windows.Forms.ToolTipIcon]::Error }
        default { [System.Windows.Forms.ToolTipIcon]::Info }
    }
    
    $notification.BalloonTipText = $Message
    $notification.BalloonTipTitle = $Title
    $notification.Visible = $true
    
    # 通知を表示
    $notification.ShowBalloonTip(5000)
    
    # 少し待ってからクリーンアップ
    Start-Sleep -Milliseconds 2000
    $notification.Dispose()
    
    Write-Host "Notification sent: $Title - $Message" -ForegroundColor Green
    
} catch {
    Write-Host "Notification failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Fallback: $Title - $Message" -ForegroundColor Cyan
}