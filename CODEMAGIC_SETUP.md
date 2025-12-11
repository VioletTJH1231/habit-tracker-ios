# 🔧 CodeMagic 配置完整指南

## ✅ 当前状态

已在项目根目录创建 **`codemagic.yaml`** 文件，包含：
- ✅ iOS 构建工作流程
- ✅ 自动化测试配置
- ✅ IPA 生成步骤
- ✅ App Store Connect 上传

## 📋 快速开始

### 1️⃣ 上传项目到 GitHub

```bash
# 在项目根目录初始化 Git
cd "d:/.AI/Ripple app/HabitTracker"
git init
git add .
git commit -m "Initial commit: HabitTracker iOS App"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/HabitTracker.git
git push -u origin main
```

### 2️⃣ 连接 CodeMagic

1. 访问 [codemagic.io](https://codemagic.io)
2. 使用 GitHub 账号登录
3. 点击 **"Add your first app"**
4. 选择 **GitHub** 作为源
5. 授权访问你的 GitHub 仓库
6. 选择 **HabitTracker** 仓库

### 3️⃣ 配置构建变量

在 CodeMagic UI 中，进入 **Workflow** > **Environment variables**，添加以下变量：

#### 必填变量

```
DEVELOPMENT_TEAM = "XXXXXXXXXX"  # Apple Team ID (10字符)
BUNDLE_ID = "com.habittracker.app"
DEVELOPER_EMAIL = "your.email@example.com"
```

#### 代码签名变量（可选）

```
PROVISIONING_PROFILE_UUID = "***"  # 从 CodeMagic 获取
CERTIFICATE_UUID = "***"           # 从 CodeMagic 获取
CERTIFICATE_PASSWORD = "***"       # 你的证书密码
PROVISIONING_PROFILE = "name"      # Provisioning Profile 名称
```

#### App Store Connect 变量（用于发布）

```
APP_STORE_CONNECT_ISSUER_ID = "***"        # App Store Connect API Issuer ID
APP_STORE_CONNECT_KEY_IDENTIFIER = "***"   # API Key ID
APP_STORE_CONNECT_PRIVATE_KEY = "***"      # API Private Key (多行)
```

## 🔐 获取代码签名证书

### 选项 A：使用 CodeMagic 自动管理（推荐）

1. 在 CodeMagic > iOS signing 中点击 **"Automatic"**
2. CodeMagic 会自动创建 App ID、证书和 Provisioning Profile
3. 只需选择 Team ID 和 Bundle ID

### 选项 B：手动上传现有证书

1. 从 Apple Developer 获取：
   - Developer Certificate (.p12)
   - Provisioning Profile (.mobileprovision)

2. 在 CodeMagic UI 中上传：
   - iOS Signing > Upload certificate
   - iOS Signing > Upload provisioning profile

## 📲 获取 Apple Team ID

1. 访问 [Apple Developer](https://developer.apple.com/account)
2. 登录你的 Apple ID
3. 进入 **Membership** 或 **Team**
4. 找到 **Team ID**（格式：XXXXXXXXXX）

## 🔑 生成 App Store Connect API 密钥

1. 访问 [App Store Connect](https://appstoreconnect.apple.com)
2. 进入 **Users and Access** > **Keys**
3. 点击 **Generate API Key**
4. 选择 **App Manager** 角色
5. 下载 `.p8` 文件
6. 在 CodeMagic 中配置：
   - `APP_STORE_CONNECT_ISSUER_ID`：从下载的密钥信息获取
   - `APP_STORE_CONNECT_KEY_IDENTIFIER`：Key ID
   - `APP_STORE_CONNECT_PRIVATE_KEY`：`.p8` 文件的完整内容

## 📊 codemagic.yaml 工作流解析

### 工作流 1：`ios-workflow`（完整构建 + 发布）

**触发条件：**
- Push 到 `main` 或 `develop` 分支
- Pull Request（排除 `*.md` 文件）

**执行步骤：**

```yaml
1. 安装依赖
   - 更新 CocoaPods
   - 检查 Swift/Xcode 版本
   - 列出可用 Schemes

2. 构建测试
   - 编译 Release 版本
   - 生成 DerivedData

3. 运行单元测试
   - 在 iPhone 15 模拟器上测试
   - 收集测试结果

4. 创建 Archive
   - 打包应用
   - 使用自动代码签名

5. 导出 IPA
   - 生成可分发的 IPA 文件
   - 应用 App Store 配置

6. 上传到 App Store Connect
   - 自动提交到 App Store（可选）
   - 发送通知邮件
```

### 工作流 2：`ios-test`（快速测试）

**触发条件：**
- Pull Request 到 `develop` 分支

**执行步骤：**
- 快速构建（跳过签名）
- 运行单元测试
- 检查编译警告

## 🚀 运行构建

### 方式 1：自动触发

```bash
# 只需 push 代码到 GitHub
git push origin main
# CodeMagic 自动开始构建
```

### 方式 2：手动触发

1. 在 CodeMagic UI 中打开 HabitTracker 项目
2. 点击 **"Start new build"**
3. 选择分支和工作流
4. 点击 **"Build"**

### 方式 3：使用 API

```bash
# 使用 CodeMagic API 触发构建
curl -X POST https://api.codemagic.io/builds \
  -H "x-auth-token: $CODEMAGIC_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "appId": "YOUR_APP_ID",
    "branch": "main",
    "workflowId": "ios-workflow"
  }'
```

## 📦 输出物

构建完成后，可在 **Artifacts** 部分下载：

```
build/HabitTracker.xcarchive  - Archive 文件
build/ipa/HabitTracker.ipa    - 可分发的 IPA（Main）
build/test-results            - 单元测试报告
build.log                      - 构建日志
archive.log                    - Archive 日志
```

## ✅ 构建检查清单

在 CodeMagic 上运行前，确保：

- [ ] `codemagic.yaml` 已提交到项目根目录
- [ ] 代码已推送到 GitHub（main 或 develop 分支）
- [ ] Apple Team ID 已获得
- [ ] 在 CodeMagic 中配置了环境变量
- [ ] 代码签名设置为 Automatic 或上传了证书
- [ ] Bundle ID 与 Apple Developer 注册的一致

## 🐛 常见问题

### ❌ "No configuration file found"

**原因：** `codemagic.yaml` 文件不在项目根目录

**解决：** 确保 `codemagic.yaml` 在以下位置：
```
HabitTracker/
├── codemagic.yaml  ✅ 这里
├── HabitTracker/
├── Makefile
├── README.md
└── ...
```

### ❌ "Xcode project not found"

**检查：**
```yaml
XCODE_WORKSPACE: "HabitTracker/HabitTracker.xcworkspace"  # 相对于项目根
XCODE_PROJECT: "HabitTracker/HabitTracker.xcodeproj"
```

### ❌ "Signing failed"

**解决方案：**
1. 在 CodeMagic UI 中选择 **Automatic** 代码签名
2. 或手动上传有效的证书
3. 确保 Bundle ID 注册在 Apple Developer

### ❌ "Archive failed"

**检查：**
```bash
# 在本地测试是否能构建
cd "d:/.AI/Ripple app/HabitTracker"
make archive
# 查看 build.log 确定错误原因
```

### ⚠️ "IPA generation failed but build succeeded"

**原因：** 通常是导出选项问题

**解决：** 使用已提供的 `ExportOptions.plist` 模板

## 📧 通知设置

构建完成后自动发送通知：

```yaml
publishing:
  email:
    recipients:
      - your.email@example.com
    notify:
      success: true      # 成功时发送
      failure: true      # 失败时发送
```

## 🔄 持续集成最佳实践

1. **分支策略**
   - `main`: 生产分支（完整构建 + App Store）
   - `develop`: 开发分支（快速测试构建）
   - `feature/*`: 功能分支（PR 触发测试）

2. **自动化流程**
   ```
   Push to main → Full Build → Test → Archive → Sign → Export IPA → Upload to App Store
   ```

3. **版本管理**
   - 在 `Info.plist` 中维护版本号
   - 构建时自动读取版本号

4. **安全**
   - 敏感信息（密钥）只存储在 CodeMagic 中
   - 不要在 `codemagic.yaml` 中写入明文密钥
   - 定期轮换 API 密钥

## 📚 相关资源

- [CodeMagic 官方文档](https://docs.codemagic.io)
- [iOS 构建配置](https://docs.codemagic.io/flutter-ios/building-ios-apps)
- [代码签名指南](https://docs.codemagic.io/code-signing/ios-code-signing)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api)

## 📞 获取帮助

- **CodeMagic 支持**：support@codemagic.io
- **Apple 开发者论坛**：https://developer.apple.com/forums
- **Stack Overflow**：标签 `codemagic`, `xcode`, `ios`

---

**配置版本**：1.0  
**最后更新**：2025年12月11日  
**状态**：✅ 生产就绪
