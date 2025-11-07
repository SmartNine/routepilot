# 贡献指南

感谢你考虑为 RoutePilot 做出贡献！

## 如何贡献

### 报告 Bug

如果你发现了 Bug，请创建一个 Issue 并包含以下信息：

- Bug 的详细描述
- 复现步骤
- 期望的行为
- 实际的行为
- 截图（如果适用）
- 环境信息（操作系统、Flutter版本等）

### 提出新功能

如果你有新功能的想法：

1. 先检查 Issues 看是否已有类似建议
2. 创建一个新的 Issue 描述你的想法
3. 等待维护者的反馈

### 提交代码

#### 1. Fork 项目
```bash
# 在 GitHub 上 Fork 项目
# 克隆你的 Fork
git clone https://github.com/YOUR_USERNAME/routepilot.git
cd routepilot
```

#### 2. 创建分支
```bash
git checkout -b feature/your-feature-name
# 或
git checkout -b fix/your-bug-fix
```

#### 3. 进行修改
- 遵循项目的编码规范
- 添加必要的测试
- 更新文档（如果需要）

#### 4. 提交变更
```bash
git add .
git commit -m "feat: add new feature"
# 或
git commit -m "fix: resolve bug"
```

提交信息格式：
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式（不影响功能）
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

#### 5. 推送到你的 Fork
```bash
git push origin feature/your-feature-name
```

#### 6. 创建 Pull Request
- 在 GitHub 上创建 Pull Request
- 清晰描述你的改动
- 关联相关的 Issue
- 等待代码审查

## 代码规范

### Dart/Flutter
- 使用 `flutter format` 格式化代码
- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart)
- 使用有意义的变量名和函数名

### JavaScript/Node.js
- 使用 ESLint 检查代码
- 使用 Prettier 格式化代码
- 遵循 Airbnb JavaScript Style Guide

## 测试

在提交 PR 前，请确保：

```bash
# Flutter 测试
cd frontend
flutter test
flutter analyze

# Node.js 测试
cd backend
npm test
npm run lint
```

## 文档

如果你的改动影响了用户使用方式：

- 更新 README.md
- 更新相关文档文件
- 添加代码注释

## 行为准则

- 尊重所有贡献者
- 接受建设性的批评
- 专注于对项目最有利的事情
- 对社区成员表现出同理心

## 问题？

如果有任何疑问，欢迎：
- 创建 Issue
- 发送邮件至 contribute@routepilot.com
- 加入我们的 Discord 频道

再次感谢你的贡献！🎉
