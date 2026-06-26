@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo [1/2] 크롤링 + 데이터 생성 (--auto)
python "%~dp0etf_holdings.py" --auto
echo.
echo [2/2] GitHub 업로드
git add -A
git commit -m "데이터 갱신 %date% %time%" || echo (변경사항 없음 - 커밋 건너뜀)
git push
echo.
echo === 완료 ===
