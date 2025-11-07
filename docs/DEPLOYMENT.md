# RoutePilot 部署指南

## 📱 多平台发布指南

### 1. Android 发布

#### 准备工作
1. 创建签名密钥
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias routepilot
```

2. 配置 `frontend/android/key.properties`
```properties
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=routepilot
storeFile=/path/to/key.jks
```

3. 更新 `frontend/android/app/build.gradle`
```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 构建 APK
```bash
cd frontend
flutter build apk --release
```

输出: `build/app/outputs/flutter-apk/app-release.apk`

#### 构建 App Bundle (Google Play)
```bash
flutter build appbundle --release
```

输出: `build/app/outputs/bundle/release/app-release.aab`

#### 发布到 Google Play
1. 登录 [Google Play Console](https://play.google.com/console)
2. 创建应用
3. 上传 AAB 文件
4. 填写应用信息、截图
5. 提交审核

---

### 2. iOS 发布

#### 准备工作
1. Apple Developer 账号 ($99/年)
2. 配置 Bundle ID
3. 创建 App ID 和证书

#### 构建 IPA
```bash
cd frontend
flutter build ipa
```

#### 使用 Xcode 发布
1. 打开 `frontend/ios/Runner.xcworkspace`
2. 选择 Product > Archive
3. 上传到 App Store Connect
4. 提交审核

#### 注意事项
- 需要添加隐私权限说明 (Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要访问位置以显示您的当前位置</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>需要访问位置以规划配送路线</string>
```

---

### 3. Web 发布

#### 构建生产版本
```bash
cd frontend
flutter build web --release
```

输出目录: `build/web/`

#### 部署选项

##### 选项 1: Firebase Hosting
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

##### 选项 2: Netlify
1. 访问 [Netlify](https://www.netlify.com/)
2. 拖放 `build/web` 文件夹
3. 配置自定义域名

##### 选项 3: 自己的服务器 (Nginx)
```nginx
server {
    listen 80;
    server_name routepilot.example.com;
    root /var/www/routepilot;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

#### Web 配置注意事项
1. 更新 `frontend/web/index.html` 中的 Google Maps API Key
2. 配置 CORS 允许跨域请求
3. 启用 HTTPS (推荐使用 Let's Encrypt)

---

### 4. Windows 桌面发布

#### 构建 Windows 应用
```bash
flutter build windows --release
```

输出目录: `build/windows/runner/Release/`

#### 创建安装程序
使用 [Inno Setup](https://jrsoftware.org/isinfo.php) 创建 Windows 安装包

```ini
[Setup]
AppName=RoutePilot
AppVersion=1.0.0
DefaultDirName={pf}\RoutePilot
DefaultGroupName=RoutePilot
OutputBaseFilename=RoutePilot-Setup
Compression=lzma2
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
```

---

### 5. macOS 桌面发布

#### 构建 macOS 应用
```bash
flutter build macos --release
```

输出: `build/macos/Build/Products/Release/routepilot.app`

#### 代码签名和公证
1. 需要 Apple Developer 账号
2. 使用 Xcode 签名
3. 公证应用以通过 Gatekeeper

---

## 🔧 后端部署

### 选项 1: Heroku
```bash
cd backend
heroku create routepilot-api
heroku config:set GOOGLE_MAPS_API_KEY=your_key
git push heroku main
```

### 选项 2: AWS EC2
```bash
# 连接到 EC2 实例
ssh -i your-key.pem ubuntu@your-ec2-ip

# 安装 Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 部署应用
git clone your-repo
cd routepilot/backend
npm install
npm install -g pm2

# 配置环境变量
cp .env.example .env
nano .env

# 启动服务
pm2 start server.js --name routepilot-api
pm2 save
pm2 startup
```

### 选项 3: Docker
```dockerfile
# Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

```bash
docker build -t routepilot-backend .
docker run -d -p 3000:3000 --env-file .env routepilot-backend
```

---

## 🔐 安全配置

### API Key 保护
1. **前端**: 使用环境变量，不要硬编码
2. **后端**: 存储在 .env 文件中
3. **限制 API Key 使用**:
   - 设置 HTTP referrer 限制
   - 设置 IP 地址限制
   - 启用 API 配额

### HTTPS 配置
```bash
# 使用 Let's Encrypt
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d api.routepilot.com
```

---

## 📊 监控和日志

### 应用监控
- 使用 Firebase Analytics (移动端)
- 使用 Google Analytics (Web)
- 使用 Sentry 进行错误追踪

### 服务器监控
```bash
# PM2 监控
pm2 monit

# 查看日志
pm2 logs routepilot-api
```

---

## 🚀 CI/CD 配置

### GitHub Actions 示例
```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
```

---

## 📱 应用商店优化 (ASO)

### 关键要素
- **应用名称**: RoutePilot - 配送路线优化
- **关键词**: 配送, 路线规划, 导航, 送货, 物流
- **描述**: 强调核心功能和价值
- **截图**: 展示主要功能界面
- **演示视频**: 30-60秒功能演示

---

## 🔄 更新策略

### 版本号管理
- 遵循语义化版本: `MAJOR.MINOR.PATCH`
- 更新 `pubspec.yaml` 中的版本号
- 更新 `package.json` 中的版本号

### 应用更新
- Android: 自动通过 Google Play 更新
- iOS: 自动通过 App Store 更新
- Web: 部署后立即生效
- 桌面: 需要用户手动下载安装

---

## 📞 支持

遇到部署问题？
- 查看文档: README.md
- 提交 Issue: GitHub Issues
- 邮件联系: support@routepilot.com
