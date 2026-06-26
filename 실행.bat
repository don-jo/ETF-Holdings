@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo   개별종목 보유 ETF 분석 실행
echo ============================================
echo.
where python >nul 2>nul
if errorlevel 1 (
  echo [오류] Python이 설치되어 있지 않습니다.
  echo https://www.python.org/downloads/ 에서 설치 후 다시 실행하세요.
  echo 설치 시 "Add Python to PATH" 체크 필수.
  pause
  exit /b
)
echo 필요한 패키지 확인/설치 중...
python -m pip install --quiet pykrx openpyxl pandas tqdm
echo.
python "%~dp0etf_holdings.py"
pause
