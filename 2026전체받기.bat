@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   2026년 전체 거래일 자동 수집  (밤새 켜두세요)
echo   - 3일치씩 받고 다 받을 때까지 자동 반복
echo   - throttle 걸리면 알아서 40분 쉬었다 재시도
echo   - 매 배치마다 GitHub 업로드(웹 자동 반영)
echo   - 중간에 닫아도 다시 실행하면 이어받습니다
echo ============================================================
echo.
python -m pip install --quiet pykrx openpyxl pandas tqdm

set /a TRIES=0
:loop
set /a TRIES+=1
echo.
echo ============== 시도 %TRIES%회차  %date% %time% ==============
if exist ".git\index.lock" del /f /q ".git\index.lock"
python "%~dp0etf_holdings.py" --year 2026
set CODE=%errorlevel%
echo [종료코드 %CODE%]

echo --- GitHub 업로드 ---
if exist ".git\index.lock" del /f /q ".git\index.lock"
git add -A
git commit -m "2026 자동수집 %date% %time%"
git push

if "%CODE%"=="0" goto done
if %TRIES% GEQ 120 goto giveup
if "%CODE%"=="3" (
  echo throttle 감지 - 40분 쉬었다 다시 받습니다...
  timeout /t 2400 /nobreak >nul
) else (
  echo 다음 배치로 - 15초 후 계속, 새로 로그인합니다...
  timeout /t 15 /nobreak >nul
)
goto loop

:giveup
echo.
echo 120회 도달로 일단 멈춥니다. 다시 실행하면 이어받아요.
goto end
:done
echo.
echo =================  2026년 전체 수집 완료!  =================
:end
pause
