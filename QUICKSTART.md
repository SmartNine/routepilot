# 🚀 RoutePilot 5分钟快速开始

## 前置要求

- ✅ Flutter 3.0+
- ✅ Node.js 18+
- ✅ Git

## 快速启动 (3步)

### 1️⃣ 克隆并安装

```bash
# 克隆项目
git clone <repository-url>
cd routepilot

# 安装后端依赖
cd backend
npm install
cp .env.example .env

# 安装前端依赖
cd ../frontend
flutter pub get
```

### 2️⃣ 启动后端

```bash
# 在 backend 目录
npm run dev
```

后端将运行在 http://localhost:3000

### 3️⃣ 启动前端

```bash
# 在 frontend 目录

# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows

# macOS
flutter run -d macos
```

## 🎯 试试这个示例

1. 在起点输入：`仓库A`
2. 添加目的地：
   - `客户1`
   - `客户2`
   - `客户3`
3. 点击"生成最优路线"
4. 查看优化结果！

## 📝 注意事项

- **首次运行**: 由于使用模拟数据，不需要 Google Maps API Key
- **真实数据**: 如需使用真实地理数据，请：
  1. 获取 [Google Maps API Key](https://console.cloud.google.com/)
  2. 编辑 `backend/.env`，添加 API Key
  3. 编辑 `frontend/lib/config/app_config.dart`，添加 API Key

## 🛠️ 常用命令

```bash
# 清理并重新构建
flutter clean && flutter pub get

# 查看可用设备
flutter devices

# 构建发布版本
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
flutter build windows    # Windows
```

## 📚 更多文档

- [完整 README](README.md)
- [开发指南](docs/DEVELOPMENT.md)
- [部署指南](docs/DEPLOYMENT.md)
- [贡献指南](CONTRIBUTING.md)

## 🆘 遇到问题？

### Flutter 相关
```bash
flutter doctor          # 检查环境
flutter clean           # 清理构建
```

### Node.js 相关
```bash
rm -rf node_modules
npm install            # 重新安装依赖
```

### 常见错误

**"端口被占用"**
```bash
# 修改 backend/server.js 中的 PORT
# 或杀掉占用进程
lsof -i :3000
kill -9 <PID>
```

**"Flutter SDK not found"**
```bash
# 确保 Flutter 在 PATH 中
flutter doctor
```

## 💡 下一步

- 🎨 自定义 UI 主题
- 🔌 集成真实的 Google Maps API
- 📊 添加数据分析功能
- 🚀 部署到生产环境

## 📞 获取帮助

- 📖 查看文档
- 🐛 提交 Issue
- 💬 加入讨论

---

**开始构建吧！** 🎉

更新配置后重启服务:
```bash
# 重启后端
npm run dev

# 重启前端
r (热重载)
R (热重启)
```
