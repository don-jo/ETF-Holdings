@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   git / data.json 복구  (GitHub의 정상본으로 되돌림)
echo ============================================================
echo.
echo [1/3] 깨진 잠금/색인 파일 삭제...
if exist ".git\index.lock" del /f /q ".git\index.lock"
if exist ".git\index" del /f /q ".git\index"
echo [2/3] 마지막 정상 커밋 상태로 복구...
git reset --hard HEAD
echo [3/3] data 폴더의 미완성 임시파일 정리...
git clean -fd data
echo.
echo === data.json 검증 ===
python -c "import json; d=json.load(open('data/data.json',encoding='utf-8')); print('  data.json 정상! 날짜', len(d['dates']), '개')"
echo.
echo 복구 끝났습니다. 이제 2026전체받기.bat 을 실행하면 이어받습니다.
pause
