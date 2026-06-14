# 使用说明

## 安装Workflow

### 方法1：直接导入（推荐）

1. 确保您已安装Node.js（下载地址：https://nodejs.org/）
2. 在项目文件夹中找到 `translator.alfredworkflow` 文件
3. 双击该文件，Alfred 5 会自动打开并导入Workflow

### 方法2：手动创建（如果方法1失败）

如果直接导入失败，您可以手动创建Workflow：

1. 打开Alfred 5 偏好设置 (⌘+,)
2. 切换到 `Workflows` 标签
3. 点击右下角的 `+` 号，选择 `Blank Workflow`
4. 填写基本信息：
   - Name: `English to Chinese Translator`
   - Bundle Id: `com.example.translator`
   - Description: `English to Chinese translator using Baidu Translate API (free)`
5. 点击 `Create`

## 配置Workflow

### 添加关键字输入

1. 在Workflow编辑器中，右键点击空白处，选择 `Inputs` → `Keyword`
2. 配置以下参数：
   - Keyword: `tr`
   - Title: `English to Chinese Translator`
   - Subtext: `Translate English to Chinese`
   - Argument type: `Optional`

### 添加脚本动作

1. 在Workflow编辑器中，右键点击空白处，选择 `Actions` → `Run Script`
2. 配置以下参数：
   - Language: `/bin/bash` 或 `/bin/zsh`（选择您的默认shell）
   - Script:
     ```bash
     cd /path/to/your/workflow/folder
     node index.js "{query}"
     ```
   注意：需要将 `/path/to/your/workflow/folder` 替换为实际的项目目录路径

### 添加环境变量

1. 在Workflow编辑器中，右键点击空白处，选择 `Utilities` → `Environment Variables`
2. 点击 `+` 号添加两个环境变量：
   - Name: `BAIDU_APP_ID`，Value: [您的百度翻译API应用ID]
   - Name: `BAIDU_APP_KEY`，Value: [您的百度翻译API密钥]

## 获取百度翻译API密钥

1. 访问 [百度翻译开放平台](https://fanyi-api.baidu.com/)
2. 注册或登录百度账号
3. 进入[控制台](https://fanyi-api.baidu.com/api/trans/product/desktop)
4. 创建应用：
   - 应用类型：选择"通用翻译API"
   - 应用名称：随意填写（如"Alfred Translator"）
   - 用途：选择"个人/研究"
5. 创建完成后，在应用列表中即可看到APP ID和密钥

## 测试Workflow

1. 确保Workflow已保存
2. 打开Alfred (⌘+空格)
3. 输入 `tr hello world` 并按回车
4. 如果配置正确，您应该会看到翻译结果

## 常见问题

### 1. 输入 `tr` 后没有显示Workflow

**可能的原因：**
- Workflow未正确导入
- 关键词冲突（其他Workflow也使用了`tr`作为关键词）
- 脚本路径配置错误

**解决方法：**
1. 检查Workflow是否已正确导入
2. 尝试使用其他关键词，如`trans`
3. 确保脚本路径配置正确

### 2. 翻译失败

**可能的原因：**
- API密钥配置错误
- 网络连接问题
- 百度翻译API服务问题

**解决方法：**
1. 检查环境变量配置
2. 验证API密钥是否有效
3. 检查网络连接
4. 查看Alfred的调试控制台（点击Workflow右上角的bug图标）

### 3. 脚本无法执行

**可能的原因：**
- Node.js未安装
- 脚本权限问题
- 项目依赖未安装

**解决方法：**
1. 确认Node.js已安装
2. 确保项目文件夹中有node_modules文件夹
3. 尝试重新安装依赖：
   ```bash
   cd /path/to/your/workflow/folder
   npm install
   ```

## 调试

### 查看错误日志

1. 在Workflow编辑器中点击右上角的bug图标（Debug Console）
2. 在Alfred中使用Workflow
3. 错误信息会显示在调试控制台中

### 手动测试脚本

您可以在项目文件夹中直接测试脚本：

```bash
cd /path/to/your/workflow/folder
export BAIDU_APP_ID="您的APP_ID"
export BAIDU_APP_KEY="您的APP_KEY"
node index.js "Hello, world!"
```

## 更新Workflow

如果您修改了代码，需要：

1. 保存修改
2. 重新导入Workflow（删除旧版本后再导入）
3. 或者在Alfred中重新加载Workflow

## 卸载

1. 打开Alfred 5 偏好设置
2. 切换到 `Workflows` 标签
3. 右键点击 `English to Chinese Translator` 工作流
4. 选择 `Delete`
