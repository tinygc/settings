#!/bin/bash

# settings リポジトリ 統合インストールスクリプト
# このスクリプトはAGENTS.mdと各種settings.jsonを適切な場所に配置します

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Settings インストールスクリプト"
echo "======================================"
echo ""

# OS判定
OS_TYPE=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="linux"
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
    VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS_TYPE="windows"
    VSCODE_CONFIG_DIR="$APPDATA/Code/User"
else
    echo "⚠️  警告: OSの検出に失敗しました。手動で設定してください。"
    OS_TYPE="unknown"
fi

echo "検出されたOS: $OS_TYPE"
echo ""


# インストール項目の選択
echo "インストールする項目を選択してください:"
echo "  1) すべてインストール（推奨）"
echo "  2) AGENTS.md のみ"
echo "  3) VSCode settings.json のみ"
echo "  4) Claude Code settings.json のみ"
echo "  5) Codex CLI (AGENTS) のみ"
echo "  6) カスタム選択"
read -p "選択 (1-6): " INSTALL_CHOICE

INSTALL_AGENTS=false
INSTALL_VSCODE=false
INSTALL_CLAUDE=false
INSTALL_CODEX=false

case $INSTALL_CHOICE in
    1)
        INSTALL_AGENTS=true
        INSTALL_VSCODE=true
        INSTALL_CLAUDE=true
        INSTALL_CODEX=true
        ;;
    2)
        INSTALL_AGENTS=true
        ;;
    3)
        INSTALL_VSCODE=true
        ;;
    4)
        INSTALL_CLAUDE=true
        ;;
    5)
        INSTALL_CODEX=true
        ;;
    6)
        read -p "AGENTS.md をインストールしますか? (y/n): " ans
        [[ $ans =~ ^[Yy]$ ]] && INSTALL_AGENTS=true
        
        read -p "VSCode settings.json をインストールしますか? (y/n): " ans
        [[ $ans == "y" ]] && INSTALL_VSCODE=true
        
        read -p "Claude Code settings.json をインストールしますか? (y/n): " ans
        [[ $ans == "y" ]] && INSTALL_CLAUDE=true
        
        read -p "Codex CLI 用 AGENTS をインストールしますか? (y/n): " ans
        [[ $ans == "y" ]] && INSTALL_CODEX=true
        ;;
    *)
        echo "❌ 無効な選択です"
        exit 1
        ;;
esac

echo ""
echo "======================================"
echo ""

# AGENTS.md のインストール
if [[ "$INSTALL_AGENTS" == "true" ]]; then
    echo "📋 AGENTS.md のインストール"
    echo "--------------------------------"
    
    AGENTS_FILE="${SCRIPT_DIR}/AGENTS.md"
    
    if [ ! -f "${AGENTS_FILE}" ]; then
        echo "❌ エラー: AGENTS.md が見つかりません"
        echo "   場所: ${AGENTS_FILE}"
    else
        # GitHub Copilot用にAGENTS.mdとして配置
        if cp "${AGENTS_FILE}" ~/AGENTS.md; then
            echo "✅ ~/AGENTS.md に配置完了（GitHub Copilot用）"
        else
            echo "⚠️  ~/AGENTS.md への配置に失敗しました"
        fi
        
        # Claude Code用にCLAUDE.mdとして配置
        mkdir -p ~/.claude
        if cp "${AGENTS_FILE}" ~/CLAUDE.md; then
            echo "✅ ~/CLAUDE.md に配置完了（Claude Code用）"
        else
            echo "⚠️  ~/CLAUDE.md への配置に失敗しました"
        fi
        
        if cp "${AGENTS_FILE}" ~/.claude/CLAUDE.md; then
            echo "✅ ~/.claude/CLAUDE.md に配置完了（Claude Code用）"
        else
            echo "⚠️  ~/.claude/CLAUDE.md への配置に失敗しました"
        fi
    fi
    
    echo ""
fi

# Codex CLI 用 AGENTS のインストール
if [ "$INSTALL_CODEX" = true ]; then
    echo "📋 Codex CLI 用 AGENTS のインストール"
    echo "--------------------------------"
    
    CODEX_AGENTS_FILE="${SCRIPT_DIR}/AGENTS.md"
    
    if [ ! -f "${CODEX_AGENTS_FILE}" ]; then
        echo "❌ エラー: AGENTS.md が見つかりません"
        echo "   場所: ${CODEX_AGENTS_FILE}"
    else
        # ~/.codex と ~/.config/codex に配置（環境によりどちらを使うか）
        mkdir -p ~/.codex
        if cp "${CODEX_AGENTS_FILE}" ~/.codex/AGENTS.md; then
            echo "✅ ~/.codex/AGENTS.md に配置完了"
        else
            echo "⚠️  ~/.codex/AGENTS.md への配置に失敗しました"
        fi

        mkdir -p ~/.config/codex
        if cp "${CODEX_AGENTS_FILE}" ~/.config/codex/AGENTS.md; then
            echo "✅ ~/.config/codex/AGENTS.md に配置完了"
        else
            echo "⚠️  ~/.config/codex/AGENTS.md への配置に失敗しました"
        fi
    fi
    
    echo ""
fi

# VSCode settings.json のインストール
if [ "$INSTALL_VSCODE" = true ]; then
    echo "📋 VSCode settings.json のインストール"
    echo "--------------------------------"
    
    VSCODE_SETTINGS="${SCRIPT_DIR}/VSCode/settings.json"
    
    if [ ! -f "${VSCODE_SETTINGS}" ]; then
        echo "❌ エラー: VSCode/settings.json が見つかりません"
        echo "   場所: ${VSCODE_SETTINGS}"
    elif [ "$OS_TYPE" = "unknown" ]; then
        echo "⚠️  OS検出失敗のため、手動でインストールしてください"
        echo "   ファイル: ${VSCODE_SETTINGS}"
    else
        # VSCode設定ディレクトリの作成
        mkdir -p "${VSCODE_CONFIG_DIR}"
        
        # バックアップの作成
        if [ -f "${VSCODE_CONFIG_DIR}/settings.json" ]; then
            BACKUP_FILE="${VSCODE_CONFIG_DIR}/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
            cp "${VSCODE_CONFIG_DIR}/settings.json" "${BACKUP_FILE}"
            echo "📦 既存の設定をバックアップ: ${BACKUP_FILE}"
        fi
        
        # settings.jsonのコピー
        if cp "${VSCODE_SETTINGS}" "${VSCODE_CONFIG_DIR}/settings.json"; then
            echo "✅ ${VSCODE_CONFIG_DIR}/settings.json に配置完了"
        else
            echo "⚠️  ${VSCODE_CONFIG_DIR}/settings.json への配置に失敗しました"
        fi
    fi
    
    echo ""
fi

# Claude Code settings.json のインストール
if [ "$INSTALL_CLAUDE" = true ]; then
    echo "📋 Claude Code settings.json のインストール"
    echo "--------------------------------"
    
    CLAUDE_SETTINGS="${SCRIPT_DIR}/ClaudeCode/settings.json"
    
    if [ ! -f "${CLAUDE_SETTINGS}" ]; then
        echo "❌ エラー: ClaudeCode/settings.json が見つかりません"
        echo "   場所: ${CLAUDE_SETTINGS}"
    else
        # .claudeディレクトリの作成
        mkdir -p ~/.claude
        
        # バックアップの作成
        if [ -f ~/.claude/settings.json ]; then
            BACKUP_FILE="$HOME/.claude/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
            cp ~/.claude/settings.json "${BACKUP_FILE}"
            echo "📦 既存の設定をバックアップ: ${BACKUP_FILE}"
        fi
        
        # settings.jsonのコピー
        if cp "${CLAUDE_SETTINGS}" ~/.claude/settings.json; then
            echo "✅ ~/.claude/settings.json に配置完了"
        else
            echo "⚠️  ~/.claude/settings.json への配置に失敗しました"
        fi
    fi
    
    echo ""
fi

# プロジェクト向けインストール（オプション）
if [ "$INSTALL_AGENTS" = true ]; then
    echo "📋 プロジェクト向け配置（オプション）"
    echo "----------------------------------------"
    echo "プロジェクトルートのパスを入力してください（スキップする場合はEnter）:"
    read -r PROJECT_ROOT
    
    if [ -n "${PROJECT_ROOT}" ]; then
        if [ -d "${PROJECT_ROOT}" ]; then
            AGENTS_FILE="${SCRIPT_DIR}/AGENTS.md"
            
            # プロジェクトルートに配置
            if cp "${AGENTS_FILE}" "${PROJECT_ROOT}/AGENTS.md"; then
                echo "✅ ${PROJECT_ROOT}/AGENTS.md に配置完了"
            else
                echo "⚠️  ${PROJECT_ROOT}/AGENTS.md への配置に失敗しました"
            fi
            
            # Codex 用のプロジェクトレベル配置 (.codex または .config/codex)
            if [ "$INSTALL_CODEX" = true ]; then
                mkdir -p "${PROJECT_ROOT}/.codex"
                if cp "${AGENTS_FILE}" "${PROJECT_ROOT}/.codex/AGENTS.md"; then
                    echo "✅ ${PROJECT_ROOT}/.codex/AGENTS.md に配置完了"
                else
                    echo "⚠️  ${PROJECT_ROOT}/.codex/AGENTS.md への配置に失敗しました"
                fi
                mkdir -p "${PROJECT_ROOT}/.config/codex"
                if cp "${AGENTS_FILE}" "${PROJECT_ROOT}/.config/codex/AGENTS.md"; then
                    echo "✅ ${PROJECT_ROOT}/.config/codex/AGENTS.md に配置完了"
                else
                    echo "⚠️  ${PROJECT_ROOT}/.config/codex/AGENTS.md への配置に失敗しました"
                fi
            fi

            # .github/copilot-instructions.md として配置
            mkdir -p "${PROJECT_ROOT}/.github"
            if cp "${AGENTS_FILE}" "${PROJECT_ROOT}/.github/copilot-instructions.md"; then
                echo "✅ ${PROJECT_ROOT}/.github/copilot-instructions.md に配置完了"
            else
                echo "⚠️  ${PROJECT_ROOT}/.github/copilot-instructions.md への配置に失敗しました"
            fi
        else
            echo "⚠️  指定されたディレクトリが存在しません: ${PROJECT_ROOT}"
        fi
    else
        echo "⏭️  プロジェクト向け配置をスキップしました"
    fi
    
    echo ""
fi

echo "======================================"
echo "✨ インストール完了!"
echo ""
echo "配置された場所:"

if [ "$INSTALL_AGENTS" = true ]; then
    echo "  [AGENTS.md]"
    echo "    - ~/AGENTS.md"
    echo "    - ~/.claude/AGENTS.md"
    if [ -n "${PROJECT_ROOT}" ] && [ -d "${PROJECT_ROOT}" ]; then
        echo "    - ${PROJECT_ROOT}/AGENTS.md"
        echo "    - ${PROJECT_ROOT}/.github/copilot-instructions.md"
    fi
fi

if [ "$INSTALL_CODEX" = true ]; then
    echo "  [Codex AGENTS]"
    echo "    - ~/.codex/AGENTS.md"
    echo "    - ~/.config/codex/AGENTS.md"
    if [ -n "${PROJECT_ROOT}" ] && [ -d "${PROJECT_ROOT}" ]; then
        echo "    - ${PROJECT_ROOT}/.codex/AGENTS.md"
        echo "    - ${PROJECT_ROOT}/.config/codex/AGENTS.md"
    fi
fi

if [ "$INSTALL_VSCODE" = true ] && [ "$OS_TYPE" != "unknown" ]; then
    echo "  [VSCode settings.json]"
    echo "    - ${VSCODE_CONFIG_DIR}/settings.json"
fi

if [ "$INSTALL_CLAUDE" = true ]; then
    echo "  [Claude Code settings.json]"
    echo "    - ~/.claude/settings.json"
fi

echo ""
echo "🎉 すべての設定が完了しました!"
echo ""
