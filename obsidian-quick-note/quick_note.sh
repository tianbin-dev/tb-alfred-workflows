#!/bin/bash

# 静默追加笔记到 Obsidian（不打开 Obsidian，直接写入 MD 文件）
# 用法: ./quick_note.sh "笔记内容"
# 环境变量:
#   vault_name  - 知识库名称（默认 tb-ob）
#   file_name   - 目标 MD 文件名（不含 .md，默认 00_Inbox）
#   vault_path   - 可选：覆盖知识库完整路径；如未设则自动检测：
#                   1. $HOME/Documents/$VAULT_NAME
#                   2. iCloud 默认路径

VAULT_NAME="${vault_name:-tb-ob}"
FILE_NAME="${file_name:-00_Inbox}"
VAULT_PATH="${vault_path:-}"

QUERY="${1:-${QUERY}}"

if [ -z "$QUERY" ]; then
    echo "用法: quick_note.sh <内容>"
    exit 1
fi

if [ -n "$VAULT_PATH" ]; then
    VAULT_DIR="$VAULT_PATH"
elif [ -d "$HOME/Documents/$VAULT_NAME" ]; then
    VAULT_DIR="$HOME/Documents/$VAULT_NAME"
else
    VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/$VAULT_NAME"
fi

NOTE_FILE="$VAULT_DIR/$FILE_NAME.md"

TIME=$(date +"%H:%M")
TEXT_LINE="- $TIME $QUERY"

mkdir -p "$VAULT_DIR"
printf '%s\n' "$TEXT_LINE" >> "$NOTE_FILE"

echo "已保存到: $NOTE_FILE"
