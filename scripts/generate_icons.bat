@echo off
REM Генерация иконок приложения
REM Запуск: scripts\generate_icons.bat
REM Или из корня: flutter pub get && dart run flutter_launcher_icons

cd /d "%~dp0.."
echo [1/2] flutter pub get...
call flutter pub get
if errorlevel 1 goto :error

echo [2/2] dart run flutter_launcher_icons...
call dart run flutter_launcher_icons
if errorlevel 1 goto :error

echo.
echo === Иконки сгенерированы ===
echo Проверь: android\app\src\main\res\mipmap-*\ic_launcher.png
echo.
echo Дальше: flutter clean && flutter build apk --release
echo Удали приложение с телефона и установи заново (кеш иконок).
goto :eof

:error
echo Ошибка! Убедись что flutter и dart в PATH.
exit /b 1
