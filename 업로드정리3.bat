@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   업로드 정리 (3차) - rebase 취소 후 병합(merge) 방식
echo ============================================================
echo.
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo [1/6] 멈춘 rebase 취소...
git rebase --abort
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo.
echo [2/6] 깨진 7/30 데이터 파일을 원격 버전으로 복원...
git checkout origin/main -- data/detail_20260730.json data/stocks_20260730.json

echo.
echo [3/6] 원격 변경분 받기 (merge 방식 - 충돌 시에도 안전)...
git pull --no-rebase origin main

echo.
echo [4/6] 내 수정분 커밋...
if exist ".git\index.lock" del /f /q ".git\index.lock"
git add -A
git commit -m "KST 시각 표시 + UI 개선 + Actions 워크플로"

echo.
echo [5/6] 업로드...
git push

echo.
echo [6/6] 결과 (아래 두 숫자가 모두 0이면 성공)
git fetch origin
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
echo.
git log --oneline -3
echo.
echo ================= 확인 후 창을 닫으세요 =================
pause
