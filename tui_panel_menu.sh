#!/bin/bash
# 金总 TUI 启动面板 — 终端菜单脚本
# 窗口自动平分桌面排列

cd "$HOME" || exit

# ============================================================
# 获取屏幕分辨率
# ============================================================
SCREEN_INFO=$(system_profiler SPDisplaysDataType 2>/dev/null | grep Resolution | head -1)
SCREEN_WIDTH=$(echo "$SCREEN_INFO" | grep -oE '[0-9]+' | head -1)
SCREEN_HEIGHT=$(echo "$SCREEN_INFO" | grep -oE '[0-9]+' | tail -1)
MENU_BAR=25  # macOS 菜单栏高度

# ============================================================
# 工具函数：计算布局并打开窗口
# idx: 第几个 (0-based), total: 总数, cmd: 要执行的命令
# ============================================================
open_window() {
  local idx=$1 total=$2 cmd="$3"

  # 计算网格: cols = ceil(sqrt(total)), rows = ceil(total / cols)
  local cols rows
  cols=$(echo "sqrt($total)" | bc | sed 's/\..*//')
  [ "$cols" -lt 1 ] && cols=1
  rows=$(( (total + cols - 1) / cols ))

  local win_w=$((SCREEN_WIDTH / cols))
  local win_h=$(((SCREEN_HEIGHT - MENU_BAR) / rows))

  local col=$((idx % cols))
  local row=$((idx / cols))
  local pos_x=$((col * win_w))
  local pos_y=$((MENU_BAR + row * win_h))
  local end_x=$((pos_x + win_w))
  local end_y=$((pos_y + win_h))

  /usr/bin/osascript <<ENDOSA
tell application "Terminal"
    activate
    do script "$cmd"
    delay 0.5
    set bounds of front window to {$pos_x, $pos_y, $end_x, $end_y}
end tell
ENDOSA
}

# ============================================================
# 菜单
# ============================================================
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
echo "  6) ★ 全部启动（自动平分桌面）"
echo "  0) 退出"
echo ""
read -p "请输入数字 [0-6]: " raw_choice

# 全角→半角
choice=$(echo "$raw_choice" | sed 's/０/0/g; s/１/1/g; s/２/2/g; s/３/3/g; s/４/4/g; s/５/5/g; s/６/6/g')

# ============================================================
# 启动
# ============================================================
case $choice in
  1)
    open_window 0 1 'cd $HOME && exec "$HOME/.hermes/hermes-agent/venv/bin/hermes" chat --tui'
    echo "→ Hermes Agent 已启动"
    ;;
  2)
    open_window 0 1 'cd $HOME/GenericAgent && exec "$HOME/GenericAgent/.venv/bin/python3" frontends/tuiapp_v2.py'
    echo "→ GenericAgent 已启动"
    ;;
  3)
    open_window 0 1 'cd $HOME && exec "$HOME/.npm-global/bin/reasonix" code'
    echo "→ Reasonix 已启动"
    ;;
  4)
    KEY=$(python3 -c "import json; print(json.load(open('$HOME/.claude/settings.local.json'))['env']['ANTHROPIC_API_KEY'])")
    open_window 0 1 "cd \$HOME && ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic ANTHROPIC_API_KEY=$KEY exec \"$HOME/.npm-global/bin/claude\" --bare --model deepseek-chat"
    echo "→ Claude Code 已启动"
    ;;
  5)
    open_window 0 1 'cd $HOME/dexter && exec "$HOME/.npm-global/bin/bun" run start'
    echo "→ Dexter 已启动"
    ;;
  6)
    echo "正在逐个启动，窗口自动平分桌面..."
    TOTAL=5
    cols=$(echo "sqrt($TOTAL)" | bc | sed 's/\..*//')
    [ "$cols" -lt 1 ] && cols=1
    rows=$(( (TOTAL + cols - 1) / cols ))
    echo "  屏幕: ${SCREEN_WIDTH}x${SCREEN_HEIGHT} → ${cols}列 × ${rows}行"
    echo ""

    open_window 0 $TOTAL 'cd $HOME && exec "$HOME/.hermes/hermes-agent/venv/bin/hermes" chat --tui'
    sleep 1.5

    open_window 1 $TOTAL 'cd $HOME/GenericAgent && exec "$HOME/GenericAgent/.venv/bin/python3" frontends/tuiapp_v2.py'
    sleep 1.5

    open_window 2 $TOTAL 'cd $HOME && exec "$HOME/.npm-global/bin/reasonix" code'
    sleep 1.5

    KEY=$(python3 -c "import json; print(json.load(open('$HOME/.claude/settings.local.json'))['env']['ANTHROPIC_API_KEY'])")
    open_window 3 $TOTAL "cd \$HOME && ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic ANTHROPIC_API_KEY=$KEY exec \"$HOME/.npm-global/bin/claude\" --bare --model deepseek-chat"
    sleep 1.5

    open_window 4 $TOTAL 'cd $HOME/dexter && exec "$HOME/.npm-global/bin/bun" run start'

    echo "→ 全部启动完成！"
    ;;
  0|*)
    echo "已退出"
    exit 0
    ;;
esac

echo ""
echo "本窗口可关闭。按 Enter 键退出。"
echo ""
echo "━━━ 已备份至 GitHub: macmini0129-byte/tui-panel ━━━"
read -r
