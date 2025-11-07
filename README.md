# RoutePilot - 智能配送路线优化应用

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 📋 项目简介

RoutePilot 是一款为同城配送司机、自由职业送货员和小微商家设计的配送路线优化应用。通过智能算法，自动计算最短行车路线，帮助用户减少绕路、节省油耗与时间。

### ✨ 核心功能

- 🗺️ **智能路线规划** - 输入起点和多个目的地，自动生成最优配送顺序
- 📱 **多平台支持** - iOS、Android、Web、Windows、macOS 全平台覆盖
- 🧭 **一键导航** - 直接跳转到 Google Maps 或 Apple Maps 开始导航
- 📊 **路线详情** - 显示总距离、预计时间、每站顺序
- 🗺️ **可视化地图** - 在地图上查看完整路线和所有站点
- 💾 **本地存储** - 保存历史路线，无需登录

## 🏗️ 技术架构

### 前端 (Flutter)
```
- Flutter 3.x
- Riverpod (状态管理)
- Dio (网络请求)
- Hive (本地存储)
- Google Maps Flutter (地图展示)
- URL Launcher (导航跳转)
```

### 后端 (Node.js)
```
- Express.js
- Google Geocoding API
- Google Distance Matrix API
- 贪心 + 2-opt TSP 算法
```

## 🚀 快速开始

### 前置要求

- Flutter SDK 3.0+
- Node.js 18+
- Google Maps API Key (可选，用于真实地理数据)

### 安装步骤

#### 1. 克隆项目
```bash
git clone <repository-url>
cd routepilot
```

#### 2. 后端设置
```bash
cd backend
npm install
cp .env.example .env
# 编辑 .env 文件，添加你的 Google Maps API Key
npm run dev
```

后端服务将运行在 http://localhost:3000

#### 3. 前端设置
```bash
cd ../frontend
flutter pub get
```

#### 4. 配置 Google Maps API Key

编辑 `frontend/lib/config/app_config.dart`，替换你的 API Key：
```dart
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
```

#### 5. 运行应用

##### iOS
```bash
flutter run -d ios
```

##### Android
```bash
flutter run -d android
```

##### Web
```bash
flutter run -d chrome
```

##### Windows
```bash
flutter run -d windows
```

##### macOS
```bash
flutter run -d macos
```

## 📦 项目结构

```
routepilot/
├── frontend/                 # Flutter 前端
│   ├── lib/
│   │   ├── config/          # 配置文件
│   │   ├── models/          # 数据模型
│   │   ├── providers/       # 状态管理
│   │   ├── screens/         # 页面
│   │   ├── services/        # 服务层
│   │   ├── widgets/         # UI 组件
│   │   └── main.dart        # 入口文件
│   └── pubspec.yaml
│
├── backend/                  # Node.js 后端
│   ├── routes/              # API 路由
│   ├── services/            # 业务逻辑
│   ├── utils/               # 工具函数
│   ├── server.js            # 服务器入口
│   └── package.json
│
├── docs/                     # 文档
└── README.md
```

## 🎯 开发计划

### MVP (4周)

- ✅ Week 1: Flutter 项目初始化，基础 UI
- ✅ Week 2: 后端 API + 算法实现
- ✅ Week 3: Google Maps 集成
- ⏳ Week 4: 测试、优化、打包

### 未来规划

- [ ] 用户账号系统
- [ ] 历史路线管理
- [ ] 时间窗口约束
- [ ] 实时路况集成
- [ ] 批量地址导入
- [ ] 团队协作功能
- [ ] 数据分析报表

## 🔧 API 文档

### 路线优化
```http
POST /api/routes/optimize
Content-Type: application/json

{
  "origin": {
    "address": "Warehouse",
    "lat": 34.048,
    "lng": -118.257
  },
  "destinations": [
    {
      "address": "Customer A",
      "lat": 34.05,
      "lng": -118.28
    }
  ]
}
```

响应：
```json
{
  "task_id": "uuid",
  "origin": {...},
  "destinations": [...],
  "optimized_order": [0, 1, 2],
  "total_distance_km": 36.2,
  "total_time_min": 58,
  "created_at": "2025-01-01T00:00:00Z"
}
```

## 🛠️ 发布打包

### Android APK
```bash
cd frontend
flutter build apk --release
# 输出: build/app/outputs/flutter-apk/app-release.apk
```

### iOS App
```bash
flutter build ipa
# 使用 Xcode 上传到 App Store
```

### Web
```bash
flutter build web --release
# 输出: build/web/
```

### Windows
```bash
flutter build windows --release
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 📞 联系方式

- 问题反馈: GitHub Issues
- 邮件: mzgamecenter@gmail.com

## 🙏 致谢

- Flutter Team
- Google Maps Platform
- 所有贡献者

---

**注意**: 本项目需要 Google Maps API Key 才能使用完整功能。请访问 [Google Cloud Console](https://console.cloud.google.com/) 创建 API Key。
