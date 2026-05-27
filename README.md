# 金总 TUI 启动面板

金总 Mac mini 上的一键启动面板，双击打开终端菜单，选数字启动 5 个 AI 助手。

## 目录结构

```
应用程序/
├── 金总TUI启动面板.app/          ← macOS .app 包装器
│   └── Contents/MacOS/launcher   ← 调起终端并执行菜单脚本
└── .hermes/tui_panel_menu.sh     ← 终端菜单脚本（菜单显示、数字选择、启动命令）
```

## 功能

| 编号 | 工具 | 命令 |
|------|------|------|
| 1 | Hermes Agent TUI | `hermes chat --tui` |
| 2 | GenericAgent TUI | `python3 frontends/tuiapp_v2.py` |
| 3 | Reasonix | `reasonix code` |
| 4 | Claude Code (DeepSeek) | `claude --bare --model deepseek-chat` |
| 5 | Dexter | `bun run start` |
| 6 | 全部启动 | 逐个打开以上 5 个 |

## 路径依赖

- `.app` → 固定路径 `/Users/qclaw/Desktop/应用程序/金总TUI启动面板.app`
- 菜单脚本 → `/Users/qclaw/.hermes/tui_panel_menu.sh`
- 各工具路径见 `tui_panel_menu.sh` 中的硬编码路径
- Claude Code API Key 从 `~/.claude/settings.local.json` 的 `env.ANTHROPIC_API_KEY` 读取

## 备份/恢复

文件分散在两处，同步时需同时提交 `.app/Contents/MacOS/launcher` 和 `~/.hermes/tui_panel_menu.sh`。
