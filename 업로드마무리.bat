@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   업로드 마무리 (4차) - 충돌 시 내 버전 우선
echo ============================================================
echo.
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo [1/4] 남은 변경분 모두 커밋...
git add -A
git commit -m "로컬 정리 %date%"
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo.
echo [2/4] 원격과 병합 (충돌 나면 내 버전 채택)...
git pull --no-rebase -X ours origin main

echo.
echo [3/4] 업로드...
if exist ".git\index.lock" del /f /q ".git\index.lock"
git push

echo.
echo [4/4] 결과 - 아래 두 숫자가 모두 0이면 성공
git fetch origin
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
echo.
git log --oneline -3
pause
