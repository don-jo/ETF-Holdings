# -*- coding: utf-8 -*-
# 기존 detail_<date>.json(행마다 ETF 이름/AUM 반복)을 압축형(_etf 한 번 + 행은 e/w/v)으로 변환.
# 이미 압축된 파일은 건너뜀. (1회만 실행)
import json, os, glob
WEB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")
files = sorted(glob.glob(os.path.join(WEB, "detail_*.json")))
conv = skip = 0
before = sum(os.path.getsize(p) for p in files)
for p in files:
    d = json.load(open(p, encoding="utf-8"))
    if "_etf" in d:
        skip += 1; continue
    meta = {}; out = {"_etf": meta}
    for stock, rows in d.items():
        arr = []
        for e in rows:
            c = e.get("etf")
            if c not in meta:
                meta[c] = {"name": e.get("name"), "aum": e.get("aum")}
            arr.append({"e": c, "w": e.get("w"), "v": e.get("val")})
        out[stock] = arr
    with open(p, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False)
    conv += 1
after = sum(os.path.getsize(p) for p in files)
print(f"detail 압축 완료: 변환 {conv}개 / 이미압축 {skip}개")
print(f"용량: {before/1024/1024:.0f}MB -> {after/1024/1024:.0f}MB")
