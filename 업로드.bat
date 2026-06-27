@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo 잠금 파일 정리 중...
if exist ".git\index.lock" del /f /q ".git\index.lock"
echo.
echo 웹사이트(GitHub)로 업로드 중...
echo.
git add -A
git commit -m "데이터 업로드 %date% %time%"
git push
echo.
echo ================= 업로드 끝났습니다 =================
echo 1~2분 뒤 웹사이트에 반영됩니다.
pause
