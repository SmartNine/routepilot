#!/bin/bash

# RoutePilot 快速启动脚本

echo "🚀 RoutePilot 启动中..."
echo ""

# 检查是否在项目根目录
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 启动后端
echo "📦 启动后端服务..."
cd backend

if [ ! -d "node_modules" ]; then
    echo "安装后端依赖..."
    npm install
fi

if [ ! -f ".env" ]; then
    echo "⚠️  警告: .env 文件不存在，从 .env.example 复制..."
    cp .env.example .env
    echo "请编辑 backend/.env 文件并添加你的 Google Maps API Key"
fi

npm run dev &
BACKEND_PID=$!
echo "✅ 后端服务已启动 (PID: $BACKEND_PID)"
cd ..

sleep 3

# 启动前端
echo ""
echo "📱 启动前端应用..."
cd frontend

if [ ! -d ".dart_tool" ]; then
    echo "安装前端依赖..."
    flutter pub get
fi

echo ""
echo "选择运行平台:"
echo "1) Chrome (Web)"
echo "2) Android"
echo "3) iOS"
echo "4) macOS"
read -p "请选择 (1-4): " choice

case $choice in
    1)
        flutter run -d chrome
        ;;
    2)
        flutter run -d android
        ;;
    3)
        flutter run -d ios
        ;;
    4)
        flutter run -d macos
        ;;
    *)
        echo "默认使用 Chrome..."
        flutter run -d chrome
        ;;
esac

# 清理
kill $BACKEND_PID
echo ""
echo "👋 RoutePilot 已关闭"
