# obsidian-quick-note Workflow 优化计划

## 一、需求理解

| # | 需求 | 说明 |
|---|---|---|
| 1 | 添加 icon | Workflow 需要一个 icon（PNG），在 Alfred 列表与通知中展示 |
| 2 | 静默添加笔记，不要打开 Obsidian | 当前实现使用 `obsidian://new` URL scheme，会主动唤起 Obsidian；需改为直接写入 MD 文件 |
| 3 | 添加成功后显示 Alfred 通知 | 写入成功后触发 Alfred Notification 输出节点（现有节点可复用，但需确认文案） |
| 4 | 将快捷关键字 `on` 替换为 `km` | keyword trigger 从 `on` 改为 `km`，说明文案同步更新 |

## 二、现状分析

### 1. 当前核心文件
- `obsidian-quick-note/info.plist` — Alfred Workflow 定义（167 行）
- `obsidian-quick-note/quick_note.sh` — 辅助脚本（当前未在 info.plist 中使用，仅作参考）

### 2. 现有流程（info.plist）
`keyword-on-uid`(Keyword `on`) → `script-run-uid`(Run Script /bin/bash) → `notification-uid`(Notification)

### 3. 当前 Run Script 内容
```bash
VAULT="$vault_name"
FILE="$file_name"
QUERY="{query}"
TIME=$(date +"%H:%M")
TEXT="- $TIME $QUERY"
ENC=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$TEXT")
EV=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$VAULT")
EF=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$FILE")
open "obsidian://new?vault=$EV&file=$EF&content=$ENC&append=true"
echo "已保存: $TEXT"
```

问题：通过 `open` URL scheme 会**强制打开 Obsidian**。

### 4. 现有环境变量
- `vault_name`: `tb-ob`
- `file_name`: `00_Inbox`

### 5. 现有 Notification
- title：`Obsidian Quick Note`
- text：`笔记已保存到 Obsidian 收件箱`

## 三、实现方案

### 方案概览
- 新增 `icon.png`（放置在 Workflow 根目录，Alfred 会自动识别名为 icon.png 的文件作为 Workflow 图标）
- 修改 `info.plist`：
  - Keyword `on` → `km`
  - Run Script 从 URL scheme 改为**直接向 MD 文件追加**
  - Workflow name/subtext/readme 同步更新
  - 添加对 icon 的引用（在文件系统中放 `icon.png` 即可，plist 可选添加 workflowicon 字段）
- 保留现有的 Notification 节点以满足"添加成功后显示 Alfred 通知"
- 保留变量机制以便用户自定义 vault 路径和文件名

### 静默写入逻辑（新脚本内容）
```bash
# 读取环境变量：vault_name, file_name；可选 vault_path（用于非默认路径）
VAULT_NAME="${vault_name:-tb-ob}"
FILE_NAME="${file_name:-00_Inbox}"
VAULT_PATH="${vault_path:-}"

QUERY="{query}"

# 构造 vault 路径（优先使用显式配置，否则使用 Obsidian 默认路径 ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vault_name>）
if [ -n "$VAULT_PATH" ]; then
    VAULT_DIR="$VAULT_PATH"
else
    VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/$VAULT_NAME"
fi

# 目标文件
NOTE_FILE="$VAULT_DIR/$FILE_NAME.md"

# 格式化内容（带时间戳）
TIME=$(date +"%H:%M")
TEXT_LINE="- $TIME $QUERY"

# 确保目录存在
mkdir -p "$VAULT_DIR"

# 追加写入（静默，不打开 Obsidian）
printf '%s\n' "$TEXT_LINE" >> "$NOTE_FILE"

# 输出供调试与传递
echo "已保存到: $NOTE_FILE"
```

### Keyword 改动
- 节点 `keyword-on-uid`：
  - `<key>keyword</key><string>on</string>` → `<string>km</string>`
  - `<key>text</key>` 中的 `Obsidian Quick Note` 可保持不变或改为 `Quick Memo`
  - `<key>subtext</key>` 从"输入内容，快速记录到 Obsidian 收件箱"→"输入内容，静默追加到 Obsidian"
- README 同步更新

### Icon 方案
- 生成一张 512×512 / 256×256 的 PNG 图标（主题：笔记本/备忘录/笔+纸），使用文字工具生成，放置为 `obsidian-quick-note/icon.png`
- 同时在 Alfred Workflow 根目录保留同名文件，Alfred 会自动识别

### 文件变更清单
| 操作 | 文件 | 说明 |
|---|---|---|
| 修改 | `obsidian-quick-note/info.plist` | 关键字 `on`→`km`、Run Script 改为静默写文件、更新 subtext/readme、加入 workflow 图标引用 |
| 新增 | `obsidian-quick-note/icon.png` | Workflow 图标（PNG） |
| 保留 | `obsidian-quick-note/quick_note.sh` | 同步更新为新的静默写入脚本，便于直接执行测试 |

## 四、潜在问题与风险
1. **Obsidian Vault 路径不统一**：部分用户不使用 iCloud，而是自定义 vault 路径；方案通过新增 `vault_path` 环境变量覆盖默认路径以解决
2. **文件写入编码**：需使用 UTF-8，确保中文正常；使用 `printf` 追加，避免 `echo` 平台差异
3. **`info.plist` 为 XML 手动编辑**：要保证 XML 结构正确，否则 Alfred 无法识别；执行前/后都会做验证
4. **Icon 格式**：需确保是合法 PNG 且大小 ≤ 1MB，否则 Alfred 可能无法正常加载

## 五、验证计划
- 语法检查：使用 `xmllint --noout info.plist` 确保 XML 合法
- 功能检查（手动）：在 Alfred 中导入 Workflow 文件
  1. `km 测试内容` 应不打开 Obsidian
  2. MD 文件中出现新的一行 `- HH:MM 测试内容`
  3. Alfred 右上角出现通知 "Obsidian Quick Note / 笔记已保存到 Obsidian 收件箱"
  4. 触发关键字时的 Workflow 图标正常展示
- 文件系统检查：确认目标 MD 文件被追加内容，且 Obsidian 不会被 `open` 唤醒

## 六、执行步骤（待你确认后执行）
1. 用文字生成工具（或 SVG→PNG 工具）创建 `obsidian-quick-note/icon.png`
2. 编辑 `obsidian-quick-note/info.plist`：
   - 替换 keyword `on` 为 `km`
   - 更新 script 内容为直接写文件的脚本
   - 更新 subtext、readme 文案
   - 如果使用 Alfred Workflow icon 机制，在 Workflow 目录下保留 icon.png 即可（或在 plist 中添加 workflowicon 键指向 icon.png）
3. 同步更新 `obsidian-quick-note/quick_note.sh`，便于命令行直接测试
4. 执行 `xmllint --noout info.plist` 进行 XML 校验
5. 提交到 git 并推送到远端
