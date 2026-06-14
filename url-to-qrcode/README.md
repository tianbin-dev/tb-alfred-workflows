# Alfred Workflow: URL to QRCode

## 功能描述
将输入的 URL 生成对应的二维码图片，并在 Alfred 中直接显示。

## 安装方法

### 1. 下载 Workflow
- 确保已安装 Alfred Powerpack（需要付费版支持 Workflow）
- 下载 `url-to-qrcode.alfredworkflow` 文件

### 2. 安装依赖
```bash
# 进入项目目录
cd /path/to/url-to-qrcode

# 创建虚拟环境（推荐）
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org

# 或直接安装到系统 Python（需要管理员权限）
pip3 install qrcode[pil] --break-system-packages
```

### 3. 安装 Workflow
- 双击 `url-to-qrcode.alfredworkflow` 文件
- Alfred 会自动打开并提示安装

## 使用方法
1. 激活 Alfred（默认快捷键：Cmd+Space）
2. 输入 `qr <url>`（例如：`qr https://www.baidu.com`）
3. Alfred 会显示生成的二维码图片
4. 按 Enter 键可打开图片文件

## 项目结构
```
url-to-qrcode/
├── info.plist              # Workflow 配置文件
├── generate_qr_code.py     # 二维码生成脚本
├── requirements.txt        # 依赖库列表
└── venv/                   # Python 虚拟环境
```

## 技术细节

### 脚本功能
- 使用 `qrcode` 库生成二维码
- 将图片保存到系统临时目录
- 输出 Alfred 支持的 JSON 格式结果
- 支持直接在 Alfred 中显示二维码图像

### 配置说明
- **关键字触发器**：`qr`（支持带空格输入）
- **脚本执行器**：Python 3.x
- **输出格式**：JSON（Alfred Script Filter 格式）

## 验证方法
1. 在 Alfred 中输入 `qr https://www.baidu.com`
2. 检查是否显示二维码图像
3. 使用手机扫描二维码，验证是否指向正确的 URL

## 注意事项
- 首次使用需要安装依赖库
- 确保 Python 3.x 已正确安装
- 二维码图片会保存到系统临时目录（`/var/folders/.../T/qr_code.png`）
- 如果使用虚拟环境，确保 Workflow 配置中的 Python 路径正确

## 故障排除

### 1. 脚本未执行
- 检查 Python 3 是否已正确安装
- 验证 `generate_qr_code.py` 是否有执行权限
- 检查 Workflow 配置中的脚本路径是否正确

### 2. 二维码不显示
- 检查依赖库是否已正确安装
- 查看 Alfred 调试控制台的错误信息（Cmd+Option+C）
- 检查临时目录的写入权限

### 3. SSL 证书错误
如果安装依赖时出现 SSL 证书验证错误，使用以下命令：
```bash
pip install -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org
```

## 版本历史
- **v1.0.0**：初始版本，支持基本的 URL 转二维码功能
