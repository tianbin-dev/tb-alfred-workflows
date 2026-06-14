# English to Chinese Translator for Alfred 5

一个使用百度翻译API的英中翻译Alfred Workflow，提供免费额度。

## 功能特点

- 快速翻译英文到中文
- 支持复制翻译结果到剪贴板
- 错误处理和用户提示
- 使用百度翻译API，有免费额度（基础版：每月200万字符免费）

## 安装

1. 下载或克隆此仓库
2. 在Alfred 5中双击`.alfredworkflow`文件（如果没有，可以将项目文件夹打包成`.alfredworkflow`）
3. 配置百度翻译API密钥

## 配置

1. 在Alfred 5中打开Workflow设置
2. 找到"English to Chinese Translator"工作流
3. 点击环境变量配置（env vars）
4. 设置以下两个环境变量：

   - `BAIDU_APP_ID`: 您的百度翻译API应用ID
   - `BAIDU_APP_KEY`: 您的百度翻译API密钥

**获取百度翻译API密钥：**

1. 访问 [百度翻译开放平台](https://fanyi-api.baidu.com/)
2. 注册或登录百度账号
3. 进入[控制台](https://fanyi-api.baidu.com/api/trans/product/desktop)
4. 创建应用：
   - 应用类型：选择"通用翻译API"
   - 应用名称：随意填写（如"Alfred Translator"）
   - 用途：选择"个人/研究"
5. 创建完成后，在应用列表中即可看到APP ID和密钥

## 百度翻译API免费额度

- **基础版**：每月免费200万字符（约1500-2000个英文单词），完全免费
- **高级版**：需要付费，但提供更高的翻译字符数和并发量

对于个人使用，基础版免费额度已经足够。

## 使用方法

1. 打开Alfred（默认快捷键是⌘+空格）
2. 输入关键字 `translate` 后跟要翻译的英文文本
3. 例如：`translate Hello, world!`
4. 按Enter键复制翻译结果到剪贴板

## 开发

### 依赖

- Node.js (v14或更高版本)
- npm 或 yarn

### 安装依赖

```bash
npm install
```

### 测试

在Alfred中直接测试，或通过命令行测试：

```bash
node index.js "Hello, world!"
```

## 技术栈

- Node.js
- alfy - Alfred Workflow开发库
- OpenAI API - 提供翻译服务

## 许可证

MIT
