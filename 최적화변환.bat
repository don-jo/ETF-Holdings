@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo data.json 을 날짜별로 분리하는 중... (1회만 하면 됩니다)
python "%~dp0최적화변환.py"
echo.
echo GitHub 업로드...
if exist ".git\index.lock" del /f /q ".git\index.lock"
git add -A
git commit -m "data.json 날짜별 분리(웹 최적화) %date% %time%"
git push
echo.
echo 완료! 이제 웹페이지는 보는 날짜만 불러와서 빨라집니다.
pause
