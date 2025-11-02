@echo off

:menu
echo.
color 0A
echo Welcome to the Build Menu. You can do the following:
echo     1: Clean up Flutter App and download dependencies
echo     2: Build Android APK
echo     3: Build Tizen TPK
echo     x: Exit
set /p choice=Please select an option: 

if "%choice%"=="1" goto clean
if "%choice%"=="2" goto build_apk
if "%choice%"=="3" goto build_tpk
if /i "%choice%"=="x" goto exit
echo.
echo That is not a valid selection.
goto menu

:clean
echo.
color 09
echo Cleaning Flutter project...
call flutter clean
del pubspec.lock 2>nul
rmdir /s /q .dart_tool
rmdir /s /q build
call flutter pub get
echo.
echo [✓] Flutter cleanup and dependency fetch complete.
goto menu

:build_apk
echo.
color 09
echo Building Android APK...
call flutter build apk --split-per-abi
echo.
echo [✓] Android APK build complete.
goto menu

:build_tpk
echo.
color 09
echo Building Tizen TPK...
call flutter-tizen build tpk
echo.
echo [✓] Tizen TPK build complete.
goto menu

:exit
echo.
echo Exiting. Goodbye!
color 07
exit /b
