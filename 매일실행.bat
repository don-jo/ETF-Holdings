@echo off
chcp 65001 >nul
cd /d "%~dp0"
set LOG=%~dp0실행로그.txt
echo ====================================================>>"%LOG%"
echo [시작] %date% %time%>>"%LOG%"
echo [1/2] 크롤링 + 데이터 생성 (--auto) ... 새 거래일이면 20~40분 걸립니다
python "%~dp0etf_holdings.py" --auto
echo [크롤 종료코드 %errorlevel%]>>"%LOG%"
echo.
echo [2/2] GitHub 업로드
if exist ".git\\index.lock" del /f /q ".git\\index.lock"
git add -A
git commit -m "데이터 갱신 %date% %time%">>"%LOG%" 2>&1
git push>>"%LOG%" 2>&1
echo [완료] %date% %time%>>"%LOG%"
echo.
echo ================= 끝났습니다 (기록: 실행로그.txt) =================
if /I not "%~1"=="auto" pause
