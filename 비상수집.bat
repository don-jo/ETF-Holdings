@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   비상 수집 (내 PC에서 직접) - GitHub Actions가 막힐 때만 사용
echo ============================================================
echo.
echo  주의:
echo   - 하루 1~2회만! 반복하면 집 IP도 KRX에 차단됩니다.
echo   - 저녁 18:30 전후(자동 실행 시간)에는 돌리지 마세요.
echo.
pause

if exist ".git\index.lock" del /f /q ".git\index.lock"

echo.
echo [1/4] 원격 최신 상태 받기 (충돌 방지)...
git pull --no-rebase --no-edit origin main
if errorlevel 1 (
  echo.
  echo !! pull 실패 - 충돌 가능성. 위 메시지를 확인하세요.
  pause
  exit /b 1
)

echo.
echo [2/4] 크롤링 시작... (1155개, 약 10~20분)
rem KRX throttle 회피: GitHub 워크플로와 동일한 저속 설정
set KRX_WORKERS=3
set KRX_SLEEP=0.7
python "%~dp0etf_holdings.py" --auto --withetf
set CODE=%errorlevel%
echo [종료코드 %CODE%]

if not "%CODE%"=="0" (
  echo.
  echo !! 수집 실패 (종료코드 %CODE%^)
  echo    3 = KRX throttle - 몇 시간 뒤 다시 시도하세요.
  echo    변경분이 없으므로 업로드하지 않습니다.
  pause
  exit /b 1
)

echo.
echo [3/4] 업로드...
if exist ".git\index.lock" del /f /q ".git\index.lock"
git add -A data
git diff --cached --quiet && (echo 변경 없음 - 이미 수집된 날짜입니다) || (
  git commit -m "수동 수집 %date% %time%"
  git push
)

echo.
echo [4/4] 결과 - 아래 두 숫자가 모두 0이면 성공
git fetch origin
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
echo.
echo ================= 완료 =================
pause
