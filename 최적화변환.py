# -*- coding: utf-8 -*-
# 기존 data.json(모든 날짜 stocks 포함)을 날짜별 stocks_<date>.json 로 분리하고
# data.json 을 '날짜 목록만' 경량본으로 교체한다. (1회만 실행하면 됨)
import json, os
WEB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")
p = os.path.join(WEB, "data.json")
d = json.load(open(p, encoding="utf-8"))
stocks = d.get("stocks", {})
if not stocks:
    print("stocks가 없습니다 → 이미 경량화됨(변환 불필요).")
else:
    cnt = 0
    for date, st in stocks.items():
        with open(os.path.join(WEB, f"stocks_{date}.json"), "w", encoding="utf-8") as f:
            json.dump(st, f, ensure_ascii=False)
        cnt += 1
    slim = {"dates": sorted(d.get("dates", [])), "generated": d.get("generated", "")}
    with open(p, "w", encoding="utf-8") as f:
        json.dump(slim, f, ensure_ascii=False)
    kb = os.path.getsize(p) / 1024
    print(f"분리 완료: stocks_*.json {cnt}개 생성 / data.json {kb:.1f} KB 로 경량화")
