@echo off
echo 🎉 Claude Code タスク完了！
echo 数字あてゲームアプリの実装が完了したよ〜💖

REM Windows 10/11の場合はToastを表示
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; $balloon = New-Object System.Windows.Forms.NotifyIcon; $balloon.Icon = [System.Drawing.SystemIcons]::Information; $balloon.BalloonTipTitle = 'Claude Code 完了'; $balloon.BalloonTipText = '🎉 実装完了！お疲れ様💖'; $balloon.Visible = $true; $balloon.ShowBalloonTip(3000); Start-Sleep 4; $balloon.Dispose()}"

REM 音も鳴らす
powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\notify.wav").PlaySync();

pause