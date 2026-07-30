@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   업로드 정리 (2차) - stash 안 쓰고 안전하게
echo ============================================================
echo.
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo [1/4] 지금 작업분을 먼저 커밋...
git add -A
git commit -m "로컬 수정(KST 표시, 7/30 재크롤) %date%"

echo.
echo [2/4] 원격 변경분과 합치기(rebase)...
git pull --rebase origin main

echo.
echo [3/4] 업로드...
if exist ".git\index.lock" del /f /q ".git\index.lock"
git push

echo.
echo [4/4] 결과 확인
git log --oneline -4
echo.
echo --- 갈라짐 여부(양쪽 0이면 정상) ---
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
echo.
echo ※ 위 두 숫자가 모두 0 이면 완료.
pause
