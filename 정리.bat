@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo   파일 정리 - 로컬 + GitHub 동시 (git rm)
echo   남기는 것: etf_holdings.py / index.html / README.md
echo               .github / .gitignore / 로컬미리보기.bat / krx_계정.txt
echo ============================================================
echo.
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo [1/5] 원격 먼저 받기 (충돌 방지)...
git pull --no-rebase --no-edit origin main
if exist ".git\index.lock" del /f /q ".git\index.lock"

echo.
echo [2/5] 역할 끝난 파일 삭제 (git 추적분)...
git rm -q --ignore-unmatch "2024전체받기.bat" "2025전체받기.bat" "2026전체받기.bat"
git rm -q --ignore-unmatch "매일실행.bat" "수동실행.bat" "업로드.bat"
git rm -q --ignore-unmatch "업로드마무리.bat" "업로드정리2.bat" "업로드정리3.bat"
git rm -q --ignore-unmatch "복구.bat" "실행로그.txt"
git rm -q --ignore-unmatch "최적화변환.bat" "최적화변환.py"
git rm -q --ignore-unmatch "detail압축.bat" "detail압축.py"
git rm -q --ignore-unmatch "데이터정리.py" "pdf확인.py"

echo.
echo [3/5] 로컬 잔여물 정리 (캐시 폴더 등)...
if exist "__pycache__" rmdir /s /q "__pycache__"
if exist "cache" rmdir /s /q "cache"
if exist "충돌정리.bat" del /f /q "충돌정리.bat"

echo.
echo [4/5] 커밋 + 업로드...
if exist ".git\index.lock" del /f /q ".git\index.lock"
git add -A
git commit -m "파일 정리: 역할 끝난 스크립트 제거 (자동화는 GitHub Actions)"
git push

echo.
echo [5/5] 결과 - 아래 두 숫자가 모두 0이면 성공
git fetch origin
git rev-list --count origin/main..HEAD
git rev-list --count HEAD..origin/main
echo.
echo --- 남은 파일 목록 ---
dir /b
echo.
echo ※ 이 창을 닫은 뒤, 이 정리.bat 파일 자체는 직접 삭제하세요.
pause
