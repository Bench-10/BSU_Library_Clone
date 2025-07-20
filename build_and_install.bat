@echo off
echo 🔧 Building and Installing Flutter App...
echo.

cd android
gradlew assembleDebug

if %ERRORLEVEL% == 0 (
    echo ✅ Build successful!
    cd ..
    
    if not exist "build\app\outputs\flutter-apk" (
        mkdir "build\app\outputs\flutter-apk"
        echo 📁 Created directory structure
    )
    
    copy "android\app\build\outputs\apk\debug\app-debug.apk" "build\app\outputs\flutter-apk\app-debug.apk" >nul
    echo 📦 Copied APK to Flutter location
    
    echo 📱 Installing to device...
    flutter install --debug
    
    if %ERRORLEVEL% == 0 (
        echo 🎉 Installation complete!
    ) else (
        echo ❌ Installation failed
    )
) else (
    echo ❌ Build failed
    cd ..
)

echo.
echo ✨ Done!
pause
