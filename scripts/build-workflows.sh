#!/usr/bin/env bash
set -euo pipefail

# 为每个包含 info.plist 的子目录构建 <name>.alfredworkflow（= zip 压缩包）
# - 优先通过 `git ls-files` 列出被跟踪的文件，自动尊重 .gitignore
# - 若不在 git 仓库，则回退到手动模式：排除 node_modules/venv/__pycache__/dist 等
#
# 用法: bash scripts/build-workflows.sh [可选: 覆盖根目录]

ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
DIST="$ROOT/dist"
mkdir -p "$DIST"

echo "根目录: $ROOT"
echo "产物目录: $DIST"
echo

IN_GIT=0
if command -v git >/dev/null 2>&1; then
    if (cd "$ROOT" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        IN_GIT=1
    fi
fi

found=0
for dir in "$ROOT"/*/; do
    dir="${dir%/}"
    name="$(basename "$dir")"
    if [ ! -f "$dir/info.plist" ]; then
        continue
    fi
    found=1

    echo "--- 打包: $name ---"
    cd "$dir"

    # 收集要打包的条目（一行一个，相对当前目录）
    file_list="$(mktemp)"
    # 确保退出时清理
    trap 'rm -f "$file_list"' EXIT

    if [ "$IN_GIT" -eq 1 ]; then
        # 列出该目录下被 git 跟踪的文件，去掉 $name/ 前缀后写入
        git -C "$ROOT" ls-files -- "$name/" \
            | while IFS= read -r f; do
                  rel="${f#$name/}"
                  # 过滤掉 .alfredworkflow 产物（安全起见）
                  case "$rel" in
                      *.alfredworkflow) continue ;;
                  esac
                  [ -e "$rel" ] && printf '%s\n' "$rel"
              done > "$file_list"
    else
        for f in *; do
            [ -e "$f" ] || continue
            case "$f" in
                *.alfredworkflow) continue ;;
                node_modules|venv|.venv|__pycache__|dist|.git|.DS_Store) continue ;;
            esac
            printf '%s\n' "$f" >> "$file_list"
        done
    fi

    rm -f "$DIST/${name}.alfredworkflow"

    if [ ! -s "$file_list" ]; then
        echo "  警告: 无文件可打包，跳过"
        continue
    fi

    # zip -@ 从 stdin 读取条目（-r 对目录递归处理）
    zip -r -@ "$DIST/${name}.alfredworkflow" < "$file_list"

    cd "$ROOT"
    echo
done

if [ "$found" -eq 0 ]; then
    echo "未发现任何包含 info.plist 的子目录" >&2
    exit 1
fi

echo "=== 构建完成 ==="
ls -lh "$DIST"
