# Flutter APK Build and Install Script
# This script fixes the APK location issue and installs the app

Write-Host "🔧 Building Flutter APK..." -ForegroundColor Cyan

# Change to android directory and build
Set-Location "android"
.\gradlew assembleDebug

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful!" -ForegroundColor Green
    
    # Go back to project root
    Set-Location ".."
    
    # Create directory structure if it doesn't exist
    if (!(Test-Path "build\app\outputs\flutter-apk")) {
        New-Item -ItemType Directory -Path "build\app\outputs\flutter-apk" -Force | Out-Null
        Write-Host "📁 Created Flutter APK directory structure" -ForegroundColor Yellow
    }
    
    # Copy APK to expected location
    Copy-Item "android\app\build\outputs\apk\debug\app-debug.apk" "build\app\outputs\flutter-apk\app-debug.apk" -Force
    Write-Host "📦 Copied APK to Flutter expected location" -ForegroundColor Yellow
    
    # Install to connected device
    Write-Host "📱 Installing APK to device..." -ForegroundColor Cyan
    flutter install --debug
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 App installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Installation failed" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Build failed" -ForegroundColor Red
}

Write-Host "✨ Done!" -ForegroundColor Magenta
