# settings リポジトリ 統合インストールスクリプト (PowerShell版)
# このスクリプトはAGENTS.mdと各種settings.jsonを適切な場所に配置します

param(
    [switch]$Help
)

# エラーで停止
$ErrorActionPreference = "Stop"

# スクリプトのディレクトリを取得
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Show-Help {
    Write-Host "🚀 Settings インストールスクリプト (PowerShell版)" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "使用方法:" -ForegroundColor Yellow
    Write-Host "  .\install_settings.ps1        # 対話式インストール"
    Write-Host "  .\install_settings.ps1 -Help  # ヘルプ表示"
    Write-Host ""
    Write-Host "このスクリプトは以下を適切な場所に配置します:"
    Write-Host "- AGENTS.md (Claude Code、GitHub Copilot用)"
    Write-Host "- VSCode settings.json"
    Write-Host "- Claude Code settings.json"
    Write-Host "- Codex CLI AGENTS.md"
    Write-Host ""
    exit 0
}

if ($Help) {
    Show-Help
}

Write-Host "🚀 Settings インストールスクリプト" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# OS判定（PowerShellなので基本的にWindows）
$OSType = "windows"
$VSCodeConfigDir = "$env:APPDATA\Code\User"

Write-Host "検出されたOS: $OSType" -ForegroundColor Green
Write-Host ""

# インストール項目の選択
Write-Host "インストールする項目を選択してください:" -ForegroundColor Yellow
Write-Host "  1) すべてインストール（推奨）"
Write-Host "  2) AGENTS.md のみ"
Write-Host "  3) VSCode settings.json のみ"
Write-Host "  4) Claude Code settings.json のみ"
Write-Host "  5) Codex CLI (AGENTS) のみ"
Write-Host "  6) カスタム選択"

do {
    $InstallChoice = Read-Host "選択 (1-6)"
} while ($InstallChoice -notmatch '^[1-6]$')

$InstallAgents = $false
$InstallVSCode = $false
$InstallClaude = $false
$InstallCodex = $false

switch ($InstallChoice) {
    "1" {
        $InstallAgents = $true
        $InstallVSCode = $true
        $InstallClaude = $true
        $InstallCodex = $true
    }
    "2" {
        $InstallAgents = $true
    }
    "3" {
        $InstallVSCode = $true
    }
    "4" {
        $InstallClaude = $true
    }
    "5" {
        $InstallCodex = $true
    }
    "6" {
        $ans = Read-Host "AGENTS.md をインストールしますか? (y/n)"
        if ($ans -match '^[Yy]$') { $InstallAgents = $true }
        
        $ans = Read-Host "VSCode settings.json をインストールしますか? (y/n)"
        if ($ans -match '^[Yy]$') { $InstallVSCode = $true }
        
        $ans = Read-Host "Claude Code settings.json をインストールしますか? (y/n)"
        if ($ans -match '^[Yy]$') { $InstallClaude = $true }
        
        $ans = Read-Host "Codex CLI 用 AGENTS をインストールしますか? (y/n)"
        if ($ans -match '^[Yy]$') { $InstallCodex = $true }
    }
    default {
        Write-Host "❌ 無効な選択です" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# AGENTS.md のインストール
if ($InstallAgents) {
    Write-Host "📋 AGENTS.md のインストール" -ForegroundColor Green
    Write-Host "--------------------------------" -ForegroundColor Green
    
    $AgentsFile = Join-Path $ScriptDir "AGENTS.md"
    
    if (-not (Test-Path $AgentsFile)) {
        Write-Host "❌ エラー: AGENTS.md が見つかりません" -ForegroundColor Red
        Write-Host "   場所: $AgentsFile" -ForegroundColor Red
    } else {
        # GitHub Copilot用にAGENTS.mdとして配置
        try {
            Copy-Item $AgentsFile "$env:USERPROFILE\AGENTS.md" -Force
            Write-Host "✅ $env:USERPROFILE\AGENTS.md に配置完了（GitHub Copilot用）" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $env:USERPROFILE\AGENTS.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # Claude Code用にCLAUDE.mdとして配置
        $ClaudeDir = "$env:USERPROFILE\.claude"
        if (-not (Test-Path $ClaudeDir)) {
            New-Item -Path $ClaudeDir -ItemType Directory -Force | Out-Null
        }
        
        try {
            Copy-Item $AgentsFile "$env:USERPROFILE\CLAUDE.md" -Force
            Write-Host "✅ $env:USERPROFILE\CLAUDE.md に配置完了（Claude Code用）" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $env:USERPROFILE\CLAUDE.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        try {
            Copy-Item $AgentsFile "$ClaudeDir\CLAUDE.md" -Force
            Write-Host "✅ $ClaudeDir\CLAUDE.md に配置完了（Claude Code用）" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $ClaudeDir\CLAUDE.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

# Codex CLI 用 AGENTS のインストール
if ($InstallCodex) {
    Write-Host "📋 Codex CLI 用 AGENTS のインストール" -ForegroundColor Green
    Write-Host "--------------------------------" -ForegroundColor Green
    
    $CodexAgentsFile = Join-Path $ScriptDir "AGENTS.md"
    
    if (-not (Test-Path $CodexAgentsFile)) {
        Write-Host "❌ エラー: AGENTS.md が見つかりません" -ForegroundColor Red
        Write-Host "   場所: $CodexAgentsFile" -ForegroundColor Red
    } else {
        # ~/.codex に配置
        $CodexDir = "$env:USERPROFILE\.codex"
        if (-not (Test-Path $CodexDir)) {
            New-Item -Path $CodexDir -ItemType Directory -Force | Out-Null
        }
        
        try {
            Copy-Item $CodexAgentsFile "$CodexDir\AGENTS.md" -Force
            Write-Host "✅ $CodexDir\AGENTS.md に配置完了" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $CodexDir\AGENTS.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }

        # ~/.config/codex に配置（Windowsでは %USERPROFILE%\.config\codex）
        $ConfigCodexDir = "$env:USERPROFILE\.config\codex"
        if (-not (Test-Path $ConfigCodexDir)) {
            New-Item -Path $ConfigCodexDir -ItemType Directory -Force | Out-Null
        }
        
        try {
            Copy-Item $CodexAgentsFile "$ConfigCodexDir\AGENTS.md" -Force
            Write-Host "✅ $ConfigCodexDir\AGENTS.md に配置完了" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $ConfigCodexDir\AGENTS.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

# VSCode settings.json のインストール
if ($InstallVSCode) {
    Write-Host "📋 VSCode settings.json のインストール" -ForegroundColor Green
    Write-Host "--------------------------------" -ForegroundColor Green
    
    $VSCodeSettings = Join-Path $ScriptDir "VSCode\settings.json"
    
    if (-not (Test-Path $VSCodeSettings)) {
        Write-Host "❌ エラー: VSCode\settings.json が見つかりません" -ForegroundColor Red
        Write-Host "   場所: $VSCodeSettings" -ForegroundColor Red
    } else {
        # VSCode設定ディレクトリの作成
        if (-not (Test-Path $VSCodeConfigDir)) {
            New-Item -Path $VSCodeConfigDir -ItemType Directory -Force | Out-Null
        }
        
        # バックアップの作成
        $ExistingSettings = Join-Path $VSCodeConfigDir "settings.json"
        if (Test-Path $ExistingSettings) {
            $BackupFile = "$ExistingSettings.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            try {
                Copy-Item $ExistingSettings $BackupFile -Force
                Write-Host "📦 既存の設定をバックアップ: $BackupFile" -ForegroundColor Cyan
            } catch {
                Write-Host "⚠️  バックアップの作成に失敗しました" -ForegroundColor Yellow
            }
        }
        
        # settings.jsonのコピー
        try {
            Copy-Item $VSCodeSettings $ExistingSettings -Force
            Write-Host "✅ $ExistingSettings に配置完了" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $ExistingSettings への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

# Claude Code settings.json のインストール
if ($InstallClaude) {
    Write-Host "📋 Claude Code settings.json のインストール" -ForegroundColor Green
    Write-Host "--------------------------------" -ForegroundColor Green
    
    $ClaudeSettings = Join-Path $ScriptDir "ClaudeCode\settings.json"
    
    if (-not (Test-Path $ClaudeSettings)) {
        Write-Host "❌ エラー: ClaudeCode\settings.json が見つかりません" -ForegroundColor Red
        Write-Host "   場所: $ClaudeSettings" -ForegroundColor Red
    } else {
        # .claudeディレクトリの作成
        $ClaudeDir = "$env:USERPROFILE\.claude"
        if (-not (Test-Path $ClaudeDir)) {
            New-Item -Path $ClaudeDir -ItemType Directory -Force | Out-Null
        }
        
        # バックアップの作成
        $ExistingClaudeSettings = "$ClaudeDir\settings.json"
        if (Test-Path $ExistingClaudeSettings) {
            $BackupFile = "$ExistingClaudeSettings.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            try {
                Copy-Item $ExistingClaudeSettings $BackupFile -Force
                Write-Host "📦 既存の設定をバックアップ: $BackupFile" -ForegroundColor Cyan
            } catch {
                Write-Host "⚠️  バックアップの作成に失敗しました" -ForegroundColor Yellow
            }
        }
        
        # settings.jsonのコピー
        try {
            Copy-Item $ClaudeSettings $ExistingClaudeSettings -Force
            Write-Host "✅ $ExistingClaudeSettings に配置完了" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $ExistingClaudeSettings への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

# プロジェクト向けインストール（オプション）
if ($InstallAgents) {
    Write-Host "📋 プロジェクト向け配置（オプション）" -ForegroundColor Green
    Write-Host "----------------------------------------" -ForegroundColor Green
    Write-Host "プロジェクトルートのパスを入力してください（スキップする場合はEnter）:"
    $ProjectRoot = Read-Host
    
    if ($ProjectRoot -and (Test-Path $ProjectRoot)) {
        $AgentsFile = Join-Path $ScriptDir "AGENTS.md"
        
        # プロジェクトルートに配置
        try {
            Copy-Item $AgentsFile "$ProjectRoot\AGENTS.md" -Force
            Write-Host "✅ $ProjectRoot\AGENTS.md に配置完了" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $ProjectRoot\AGENTS.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # Codex 用のプロジェクトレベル配置
        if ($InstallCodex) {
            $ProjectCodexDir = "$ProjectRoot\.codex"
            if (-not (Test-Path $ProjectCodexDir)) {
                New-Item -Path $ProjectCodexDir -ItemType Directory -Force | Out-Null
            }
            
            try {
                Copy-Item $AgentsFile "$ProjectCodexDir\AGENTS.md" -Force
                Write-Host "✅ $ProjectCodexDir\AGENTS.md に配置完了" -ForegroundColor Green
            } catch {
                Write-Host "⚠️  $ProjectCodexDir\AGENTS.md への配置に失敗しました" -ForegroundColor Yellow
            }
            
            $ProjectConfigCodexDir = "$ProjectRoot\.config\codex"
            if (-not (Test-Path $ProjectConfigCodexDir)) {
                New-Item -Path $ProjectConfigCodexDir -ItemType Directory -Force | Out-Null
            }
            
            try {
                Copy-Item $AgentsFile "$ProjectConfigCodexDir\AGENTS.md" -Force
                Write-Host "✅ $ProjectConfigCodexDir\AGENTS.md に配置完了" -ForegroundColor Green
            } catch {
                Write-Host "⚠️  $ProjectConfigCodexDir\AGENTS.md への配置に失敗しました" -ForegroundColor Yellow
            }
        }

        # .github/copilot-instructions.md として配置
        $GithubDir = "$ProjectRoot\.github"
        if (-not (Test-Path $GithubDir)) {
            New-Item -Path $GithubDir -ItemType Directory -Force | Out-Null
        }
        
        try {
            Copy-Item $AgentsFile "$GithubDir\copilot-instructions.md" -Force
            Write-Host "✅ $GithubDir\copilot-instructions.md に配置完了" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  $GithubDir\copilot-instructions.md への配置に失敗しました" -ForegroundColor Yellow
            Write-Host "   エラー: $($_.Exception.Message)" -ForegroundColor Red
        }
    } elseif ($ProjectRoot) {
        Write-Host "⚠️  指定されたディレクトリが存在しません: $ProjectRoot" -ForegroundColor Yellow
    } else {
        Write-Host "⏭️  プロジェクト向け配置をスキップしました" -ForegroundColor Cyan
    }
    
    Write-Host ""
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "✨ インストール完了!" -ForegroundColor Green
Write-Host ""
Write-Host "配置された場所:" -ForegroundColor Yellow

if ($InstallAgents) {
    Write-Host "  [AGENTS.md]" -ForegroundColor Cyan
    Write-Host "    - $env:USERPROFILE\AGENTS.md"
    Write-Host "    - $env:USERPROFILE\.claude\AGENTS.md"
    if ($ProjectRoot -and (Test-Path $ProjectRoot)) {
        Write-Host "    - $ProjectRoot\AGENTS.md"
        Write-Host "    - $ProjectRoot\.github\copilot-instructions.md"
    }
}

if ($InstallCodex) {
    Write-Host "  [Codex AGENTS]" -ForegroundColor Cyan
    Write-Host "    - $env:USERPROFILE\.codex\AGENTS.md"
    Write-Host "    - $env:USERPROFILE\.config\codex\AGENTS.md"
    if ($ProjectRoot -and (Test-Path $ProjectRoot)) {
        Write-Host "    - $ProjectRoot\.codex\AGENTS.md"
        Write-Host "    - $ProjectRoot\.config\codex\AGENTS.md"
    }
}

if ($InstallVSCode) {
    Write-Host "  [VSCode settings.json]" -ForegroundColor Cyan
    Write-Host "    - $VSCodeConfigDir\settings.json"
}

if ($InstallClaude) {
    Write-Host "  [Claude Code settings.json]" -ForegroundColor Cyan
    Write-Host "    - $env:USERPROFILE\.claude\settings.json"
}

Write-Host ""
Write-Host "🎉 すべての設定が完了しました!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 ヒント:" -ForegroundColor Yellow
Write-Host "- VSCodeを再起動して設定を反映させてください"
Write-Host "- Claude Codeを再起動して設定を反映させてください"
Write-Host "- Execution Policyエラーが発生した場合は以下を実行してください:"
Write-Host "  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
Write-Host ""