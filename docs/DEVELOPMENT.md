# RoutePilot 开发指南

## 🎯 开发环境设置

### 必需工具

#### 1. Flutter 开发环境
```bash
# 检查 Flutter 环境
flutter doctor

# 应该看到:
# ✓ Flutter (Channel stable, 3.x.x)
# ✓ Android toolchain
# ✓ Xcode (macOS)
# ✓ Chrome
# ✓ VS Code / Android Studio
```

#### 2. Node.js 环境
```bash
# 检查版本
node --version  # 应该 >= 18.x
npm --version   # 应该 >= 9.x
```

#### 3. 推荐 IDE 插件
- **VS Code**:
  - Flutter
  - Dart
  - ESLint
  - Prettier
  - GitLens

- **Android Studio**:
  - Flutter plugin
  - Dart plugin

---

## 📁 项目结构详解

### Frontend (Flutter)

```
frontend/lib/
├── config/              # 应用配置
│   ├── app_config.dart  # API URLs, constants
│   └── theme.dart       # 主题配置
│
├── models/              # 数据模型
│   ├── location.dart    # 位置模型
│   └── route_task.dart  # 路线任务模型
│
├── providers/           # Riverpod 状态管理
│   └── route_provider.dart
│
├── screens/             # 页面
│   ├── home_screen.dart
│   └── map_screen.dart
│
├── services/            # 服务层
│   ├── api_service.dart      # API 调用
│   └── navigation_service.dart
│
├── widgets/             # 可复用组件
│   ├── location_input_card.dart
│   └── route_result_card.dart
│
└── main.dart           # 应用入口
```

### Backend (Node.js)

```
backend/
├── routes/              # API 路由
│   └── routes.js
│
├── services/            # 业务逻辑
│   ├── routeService.js
│   └── googleMapsService.js
│
├── utils/               # 工具函数
│   └── tspSolver.js     # TSP 算法
│
├── server.js            # 服务器入口
├── package.json
└── .env                 # 环境变量
```

---

## 🔧 开发工作流

### 1. 启动开发环境

#### 终端 1: 启动后端
```bash
cd backend
npm run dev  # 使用 nodemon 自动重启
```

#### 终端 2: 启动前端
```bash
cd frontend
flutter run  # 或指定设备: -d chrome, -d android, -d ios
```

### 2. 热重载

- **Flutter**: 按 `r` 热重载，`R` 热重启
- **Node.js**: nodemon 自动重启

---

## 💻 编码规范

### Dart/Flutter

#### 1. 命名规范
```dart
// 文件名: snake_case
location_input_card.dart

// 类名: PascalCase
class LocationInputCard extends StatelessWidget {}

// 变量/函数: camelCase
final locationProvider = ...;
void calculateRoute() {}

// 常量: lowerCamelCase
const maxDestinations = 20;

// 私有成员: _开头
String _apiKey;
void _handleError() {}
```

#### 2. Widget 组织
```dart
class MyWidget extends StatelessWidget {
  // 1. 构造函数
  const MyWidget({super.key, required this.title});
  
  // 2. 成员变量
  final String title;
  
  // 3. build 方法
  @override
  Widget build(BuildContext context) {
    return ...;
  }
  
  // 4. 私有辅助方法
  Widget _buildItem() { ... }
}
```

#### 3. 状态管理 (Riverpod)
```dart
// Provider 定义
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

// 使用 Provider
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return ...;
  }
}
```

### JavaScript/Node.js

#### 1. 命名规范
```javascript
// 文件名: camelCase
routeService.js

// 类名: PascalCase
class RouteService {}

// 变量/函数: camelCase
const apiService = ...;
function calculateDistance() {}

// 常量: UPPER_SNAKE_CASE
const MAX_DESTINATIONS = 20;
```

#### 2. 异步处理
```javascript
// 使用 async/await
async function optimizeRoute(task) {
  try {
    const result = await apiCall();
    return result;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}
```

#### 3. 错误处理
```javascript
// 统一错误处理中间件
app.use((err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).json({
    error: true,
    message: err.message,
  });
});
```

---

## 🧪 测试

### Flutter 测试

#### 单元测试
```dart
// test/models/location_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:routepilot/models/location.dart';

void main() {
  test('Location.fromJson creates valid object', () {
    final json = {
      'address': 'Test Address',
      'lat': 34.0,
      'lng': -118.0,
    };
    
    final location = Location.fromJson(json);
    
    expect(location.address, 'Test Address');
    expect(location.lat, 34.0);
  });
}
```

运行测试:
```bash
flutter test
```

#### Widget 测试
```dart
testWidgets('Home screen displays title', (WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: MyApp()));
  expect(find.text('RoutePilot'), findsOneWidget);
});
```

### Node.js 测试 (Jest)

```javascript
// test/tspSolver.test.js
const tspSolver = require('../utils/tspSolver');

describe('TSP Solver', () => {
  test('solves simple 3-point problem', () => {
    const matrix = [
      [0, 10, 15],
      [10, 0, 20],
      [15, 20, 0]
    ];
    
    const result = tspSolver.solve(matrix);
    expect(result).toHaveLength(2);
  });
});
```

运行测试:
```bash
npm test
```

---

## 🐛 调试技巧

### Flutter 调试

#### 1. 使用 debugPrint
```dart
debugPrint('Location: ${location.address}');
```

#### 2. Flutter DevTools
```bash
flutter run
# 在浏览器打开 DevTools URL
```

#### 3. 断点调试
- VS Code: 点击行号左侧添加断点
- 使用 F5 启动调试模式

### Node.js 调试

#### 1. Console.log
```javascript
console.log('Request:', req.body);
```

#### 2. VS Code 调试
```json
// .vscode/launch.json
{
  "type": "node",
  "request": "launch",
  "name": "Debug Backend",
  "program": "${workspaceFolder}/backend/server.js"
}
```

#### 3. Chrome DevTools
```bash
node --inspect server.js
# 在 Chrome 打开 chrome://inspect
```

---

## 🔌 API 集成

### Google Maps API 设置

#### 1. 获取 API Key
1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建项目
3. 启用以下 APIs:
   - Maps JavaScript API
   - Geocoding API
   - Distance Matrix API
4. 创建 API Key

#### 2. 配置 API Key

Frontend:
```dart
// lib/config/app_config.dart
static const String googleMapsApiKey = 'YOUR_API_KEY';
```

Backend:
```bash
# .env
GOOGLE_MAPS_API_KEY=YOUR_API_KEY
```

#### 3. API 使用示例

```javascript
// 地理编码
const result = await googleMapsService.geocode('北京市朝阳区');

// 距离矩阵
const matrix = await googleMapsService.getDistanceMatrix(
  [origin],
  destinations
);
```

---

## 📊 性能优化

### Flutter 性能

#### 1. 使用 const 构造函数
```dart
const Text('Hello')  // 而不是 Text('Hello')
```

#### 2. 避免在 build 中创建对象
```dart
// ❌ 错误
Widget build(BuildContext context) {
  final controller = TextEditingController();
  return TextField(controller: controller);
}

// ✅ 正确
final controller = TextEditingController();
Widget build(BuildContext context) {
  return TextField(controller: controller);
}
```

#### 3. 使用 ListView.builder
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### Node.js 性能

#### 1. 缓存结果
```javascript
const cache = new Map();

async function getCachedData(key) {
  if (cache.has(key)) {
    return cache.get(key);
  }
  
  const data = await fetchData(key);
  cache.set(key, data);
  return data;
}
```

#### 2. 异步并发
```javascript
// 并发执行多个请求
const results = await Promise.all([
  fetchData1(),
  fetchData2(),
  fetchData3(),
]);
```

---

## 🚀 新功能开发流程

### 1. 创建功能分支
```bash
git checkout -b feature/add-route-history
```

### 2. 开发功能
- 更新模型
- 添加 API endpoint
- 创建 UI 组件
- 编写测试

### 3. 测试
```bash
flutter test
npm test
```

### 4. 提交代码
```bash
git add .
git commit -m "feat: add route history feature"
git push origin feature/add-route-history
```

### 5. 创建 Pull Request
- 描述变更
- 关联 Issue
- 请求代码审查

---

## 📚 常用命令

### Flutter
```bash
flutter pub get          # 安装依赖
flutter clean            # 清理构建
flutter doctor           # 检查环境
flutter analyze          # 代码分析
flutter format .         # 格式化代码
flutter build apk        # 构建 APK
flutter build web        # 构建 Web
```

### Node.js
```bash
npm install              # 安装依赖
npm run dev              # 开发模式
npm start                # 生产模式
npm test                 # 运行测试
npm run lint             # 代码检查
```

---

## 🆘 常见问题

### Flutter

**Q: Android 构建失败**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Q: iOS 构建失败**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
```

### Node.js

**Q: 端口被占用**
```bash
# 查找进程
lsof -i :3000
# 杀掉进程
kill -9 <PID>
```

**Q: 依赖冲突**
```bash
rm -rf node_modules package-lock.json
npm install
```

---

## 📖 学习资源

### Flutter
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)
- [Riverpod 文档](https://riverpod.dev/)

### Node.js
- [Express 文档](https://expressjs.com/)
- [Node.js 最佳实践](https://github.com/goldbergyoni/nodebestpractices)

### 算法
- [TSP 问题详解](https://en.wikipedia.org/wiki/Travelling_salesman_problem)
- [2-opt 算法](https://en.wikipedia.org/wiki/2-opt)

---

## 👥 团队协作

### Git 工作流
1. 从 `main` 创建功能分支
2. 开发并提交
3. 创建 Pull Request
4. 代码审查
5. 合并到 `main`

### 代码审查清单
- [ ] 代码符合规范
- [ ] 有适当的注释
- [ ] 有测试覆盖
- [ ] 无明显性能问题
- [ ] UI 符合设计稿

---

**Happy Coding! 🎉**
