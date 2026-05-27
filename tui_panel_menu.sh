#!/bin/bash
# 金总 TUI 启动面板 — 终端菜单脚本
# 被 .app 调用，在新终端窗口中显示菜单

cd "$HOME" || exit

clear
echo "╔══════════════════════════════════════╗"
echo "║       金总 TUI 启动面板             ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "  1) Hermes Agent (TUI)"
echo "  2) GenericAgent TUI"
echo "  3) Reasonix"
echo "  4) Claude Code (DeepSeek)"
echo "  5) Dexter"
echo "  -------------------------------"
echo "  6) ★ 全部启动"
echo "  0) 退出"
echo ""
read -p "请输入数字 [0-6]: " raw_choice

# 把全角数字转半角
choice=$(echo "$raw_choice" | sed 's/０/0/g; s/１/1/g; s/２/2/g; s/３/3/g; s/４/4/g; s/５/5/g; s/６/6/g')

case $choice in
  1)
    osascript -e 'tell application "Terminal" to do script "cd $HOME && exec \"$HOME/.hermes/hermes-agent/venv/bin/hermes\" chat --tui"'
    echo "→ Hermes Agent 已启动"
    ;;
  2)
    osascript -e 'tell application "Terminal" to do script "cd $HOME/GenericAgent && exec \"$HOME/GenericAgent/.venv/bin/python3\" frontends/tuiapp_v2.py"'
    echo "→ GenericAgent 已启动"
    ;;
  3)
    osascript -e 'tell application "Terminal" to do script "cd $HOME && exec \"$HOME/.npm-global/bin/reasonix\" code"'
    echo "→ Reasonix 已启动"
    ;;
  4)
    KEY=$(python3 -c "import json; print(json.load(open('$HOME/.claude/settings.local.json'))['env']['ANTHROPIC_API_KEY'])")
    osascript -e "tell application \"Terminal\" to do script \"cd \$HOME && ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic ANTHROPIC_API_KEY=$KEY exec \\\"$HOME/.npm-global/bin/claude\\\" --bare --model deepseek-chat\""
    echo "→ Claude Code 已启动"
    ;;
  5)
    osascript -e 'tell application "Terminal" to do script "cd $HOME/dexter && exec \"$HOME/.npm-global/bin/bun\" run start"'
    echo "→ Dexter 已启动"
    ;;
  6)
    echo "正在逐个启动..."
    osascript -e 'tell application "Terminal" to do script "cd $HOME && exec \"$HOME/.hermes/hermes-agent/venv/bin/hermes\" chat --tui"'
    sleep 1.5
    osascript -e 'tell application "Terminal" to do script "cd $HOME/GenericAgent && exec \"$HOME/GenericAgent/.venv/bin/python3\" frontends/tuiapp_v2.py"'
    sleep 1.5
    osascript -e 'tell application "Terminal" to do script "cd $HOME && exec \"$HOME/.npm-global/bin/reasonix\" code"'
    sleep 1.5
    KEY=$(python3 -c "import json; print(json.load(open('$HOME/.claude/settings.local.json'))['env']['ANTHROPIC_API_KEY'])")
    osascript -e "tell application \"Terminal\" to do script \"cd \$HOME && ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic ANTHROPIC_API_KEY=$KEY exec \\\"$HOME/.npm-global/bin/claude\\\" --bare --model deepseek-chat\""
    sleep 1.5
    osascript -e 'tell application "Terminal" to do script "cd $HOME/dexter && exec \"$HOME/.npm-global/bin/bun\" run start"'
    echo "→ 全部已启动！"
    ;;
  0|*)
    echo "已退出"
    exit 0
    ;;
esac

echo ""
echo "本窗口可关闭。按 Enter 键退出。"
read -r
