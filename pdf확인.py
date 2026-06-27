# -*- coding: utf-8 -*-
"""
특정 ETF의 PDF(구성종목) 원본을 그대로 출력 — 원화현금/설정현금액 행이 있는지 확인용.
사용: python pdf확인.py <ETF코드 또는 이름> [날짜YYYYMMDD]
예:   python pdf확인.py 글로벌피지컬
      python pdf확인.py 458730 20260430
"""
import os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
# --- KRX 로그인 (krx_계정.txt 읽어 환경변수 설정) ---
acc = os.path.join(HERE, "krx_계정.txt")
if os.path.exists(acc):
    lines = [l.strip() for l in open(acc, encoding="utf-8")
             if l.strip() and not l.strip().startswith("#")]
    if len(lines) >= 2 and "여기에" not in lines[0]:
        os.environ["KRX_ID"] = lines[0]
        os.environ["KRX_PW"] = lines[1]

import pandas as pd
from pykrx import stock
from pykrx.website.krx.etx.core import 전종목시세_ETF
pd.set_option("display.max_rows", None)
pd.set_option("display.width", 220)
pd.set_option("display.unicode.east_asian_width", True)

arg = sys.argv[1] if len(sys.argv) > 1 else input("ETF 코드 또는 이름: ").strip()
date = sys.argv[2] if len(sys.argv) > 2 else "20260430"

code = arg
if not arg.isdigit():
    # 이름으로 검색 (한 번의 호출로 전체 ETF 이름 가져와 매칭)
    raw = 전종목시세_ETF().fetch(date)
    hit = None
    for _, r in raw.iterrows():
        nm = str(r.get("ISU_ABBRV", ""))
        if arg in nm:
            hit = (str(r.get("ISU_SRT_CD")).zfill(6), nm); break
    if hit:
        code = hit[0]; print("매칭된 ETF:", hit)
    else:
        print("이름 매칭 실패. 6자리 코드로 다시 시도하세요."); sys.exit()

print(f"\n===== {code} / {date} PDF 전체 =====")
df = stock.get_etf_portfolio_deposit_file(code, date)
if df is None or df.empty:
    print("(빈 결과 — 로그인 실패이거나 휴장일/코드 오류)")
else:
    print(df.to_string())
    print("\n행 수:", len(df), "| 컬럼:", list(df.columns))
input("\nEnter로 닫기...")
