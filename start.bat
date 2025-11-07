@echo off
chcp 65001 >nul
echo 🚀 RoutePilot 启动中...
echo.

REM 检查目录
if not exist "backend" (
    echo ❌ 错误: 请在项目根目录运行此脚本
    pause
    exit /b 1
)

REM 启动后端
echo 📦 启动后端服务...
cd backend

if not exist "node_modules" (
    echo 安装后端依赖...
    call npm install
)

if not exist ".env" (
    echo ⚠️  警告: .env 文件不存在，从 .env.example 复制...
    copy .env.example .env
    echo 请编辑 backend\.env 文件并添加你的 Google Maps API Key
)

start "RoutePilot Backend" cmd /k "npm run dev"
cd ..

timeout /t 3 /nobreak >nul

REM 启动前端
echo.
echo 📱 启动前端应用...
cd frontend

if not exist ".dart_tool" (
    echo 安装前端依赖...
    call flutter pub get
)

echo.
echo 选择运行平台:
echo 1) Chrome (Web)
echo 2) Android
echo 3) Windows
set /p choice="请选择 (1-3): "

if "%choice%"=="1" (
    flutter run -d chrome
) else if "%choice%"=="2" (
    flutter run -d android
) else if "%choice%"=="3" (
    flutter run -d windows
) else (
    echo 默认使用 Chrome...
    flutter run -d chrome
)

cd ..
echo.
echo 👋 RoutePilot 前端已关闭
pause
