@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   업로드 - 코드/문서 수정분을 GitHub에 올립니다
echo   (데이터 수집은 GitHub Actions가 자동으로 하니 무관)
echo ============================================================
echo.
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo [1/4] 원격 변경분 먼저 받기 (충돌 방지)...
git pull --no-rebase --no-edit origin main
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo.
echo [2/4] 변경분 확인...
git add -A
git status --short

echo.
echo [3/4] 커밋 + 업로드...
git commit -m "수정 업로드 %date% %time%"
git push

echo.
echo [4/4] 결과 - 아래 두 숫자가 모두 0이면 성공
git fetch origin
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
echo.
echo ※ "nothing to commit" 이 나오면 = 바뀐 게 없다는 뜻(정상)
echo ※ 1~2분 뒤 사이트에 반영됩니다
pause
