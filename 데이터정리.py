# -*- coding: utf-8 -*-
"""
data.json 에서 원하지 않는 날짜(가짜/잘못 잡힌 날짜)를 제거하고
그 날짜의 detail_<날짜>.json 도 삭제한다.
사용: 아래 REMOVE 에 지울 날짜를 넣고  python 데이터정리.py
"""
import json, os

HERE = os.path.dirname(os.path.abspath(__file__))

# ★ 지울 날짜들 (YYYYMMDD). 필요하면 더 추가.
REMOVE = ["20260624"]

dj = os.path.join(HERE, "data.json")
with open(dj, encoding="utf-8") as f:
    d = json.load(f)

before = list(d.get("dates", []))
for date in REMOVE:
    d["dates"] = [x for x in d.get("dates", []) if x != date]
    d.get("stocks", {}).pop(date, None)
    fp = os.path.join(HERE, f"detail_{date}.json")
    if os.path.exists(fp):
        os.remove(fp)
        print("삭제:", os.path.basename(fp))

with open(dj, "w", encoding="utf-8") as f:
    json.dump(d, f, ensure_ascii=False)

print("dates 변경:", before, "->", d["dates"])
print("\n완료! 이제 GitHub에 올리면(매일실행.bat 또는 git push) 사이트에 반영됩니다.")
input("Enter 키를 누르면 닫힙니다...")
