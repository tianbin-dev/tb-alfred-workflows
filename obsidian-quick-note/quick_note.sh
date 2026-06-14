#!/bin/bash

# ===== 配置区域 =====
VAULT_NAME="你的知识库名称"
FILE_NAME="00_Inbox"
# ===================

# Alfred 通过标准输入传递参数
NOTE_CONTENT=$(cat)

TIME_STAMP=$(date +"%H:%M")
FORMATTED="- ${TIME_STAMP} ${NOTE_CONTENT}"

# URL 编码函数
url_encode() {
    python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

ENCODED_CONTENT=$(url_encode "$FORMATTED")
ENCODED_VAULT=$(url_encode "$VAULT_NAME")
ENCODED_FILE=$(url_encode "$FILE_NAME")

URI="obsidian://new?vault=${ENCODED_VAULT}&file=${ENCODED_FILE}&content=${ENCODED_CONTENT}&append=true"

# 调用 Obsidian
open "$URI"

echo "笔记已保存"
