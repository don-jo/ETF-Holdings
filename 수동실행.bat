@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo 필요한 패키지 확인/설치...
python -m pip install --quiet pykrx openpyxl pandas tqdm
echo.
echo 분석 실행 (날짜 직접 입력 가능 - 과거 날짜 채우기용)
python "%~dp0etf_holdings.py"
echo.
echo GitHub 업로드 중...
if exist ".git\\index.lock" del /f /q ".git\\index.lock"
git add -A
git commit -m "데이터 갱신(수동) %date% %time%"
git push
echo.
echo ================= 끝났습니다 (웹 반영 완료) =================
pause
