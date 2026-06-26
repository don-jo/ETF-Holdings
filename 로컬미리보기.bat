@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo   로컬 미리보기 서버 시작
echo   브라우저에서 아래 주소를 여세요:
echo        http://localhost:8000
echo   (종료하려면 이 창에서 Ctrl + C)
echo ============================================
start "" http://localhost:8000
python -m http.server 8000
