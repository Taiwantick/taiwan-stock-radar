#!/bin/bash
# ================================================
# push_data.sh — 推送最新資料至 GitHub Pages
# ================================================
# 使用方式：bash push_data.sh
# ================================================

PAGES_DIR="$(cd "$(dirname "$0")" && pwd)"
DASHBOARD_DIR="$PAGES_DIR/../telegram_dashboard"
STOCK_TW_DIR="$PAGES_DIR/.."
DATA_DIR="$PAGES_DIR/data"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}📤 推送資料至 GitHub Pages...${NC}"

# 複製 JSON 資料檔
COPIED=0

# dashboard_data.json 可能來自 ~/stockbot/ 或 ~/Stock_TW/，取較新的一份
DASH_SRC=""
DASH_A="$HOME/stockbot/dashboard_data.json"
DASH_B="$STOCK_TW_DIR/dashboard_data.json"
if [ -f "$DASH_A" ] && [ -f "$DASH_B" ]; then
    # 比較修改時間，取較新的
    if [ "$DASH_A" -nt "$DASH_B" ]; then
        DASH_SRC="$DASH_A"
    else
        DASH_SRC="$DASH_B"
    fi
elif [ -f "$DASH_A" ]; then
    DASH_SRC="$DASH_A"
elif [ -f "$DASH_B" ]; then
    DASH_SRC="$DASH_B"
fi
if [ -n "$DASH_SRC" ]; then
    cp "$DASH_SRC" "$DATA_DIR/dashboard_data.json"
    echo -e "${GREEN}✅ dashboard_data.json（來源：$DASH_SRC）${NC}"
    COPIED=$((COPIED+1))
fi

if [ -f "$DASHBOARD_DIR/screener_data.json" ]; then
    cp "$DASHBOARD_DIR/screener_data.json" "$DATA_DIR/"
    echo -e "${GREEN}✅ screener_data.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ -f "$DASHBOARD_DIR/realtime_alerts.json" ]; then
    cp "$DASHBOARD_DIR/realtime_alerts.json" "$DATA_DIR/"
    echo -e "${GREEN}✅ realtime_alerts.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ -f "$DASHBOARD_DIR/insider_data.json" ]; then
    cp "$DASHBOARD_DIR/insider_data.json" "$DATA_DIR/"
    echo -e "${GREEN}✅ insider_data.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ -f "$DASHBOARD_DIR/radar_data.json" ]; then
    cp "$DASHBOARD_DIR/radar_data.json" "$DATA_DIR/"
    echo -e "${GREEN}✅ radar_data.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ -f "$DATA_DIR/kline_data.json" ]; then
    echo -e "${GREEN}✅ kline_data.json（已在 data/ 目錄）${NC}"
    COPIED=$((COPIED+1))
elif [ -f "$DASHBOARD_DIR/kline_data.json" ]; then
    cp "$DASHBOARD_DIR/kline_data.json" "$DATA_DIR/"
    echo -e "${GREEN}✅ kline_data.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ $COPIED -eq 0 ]; then
    echo -e "${RED}❌ 找不到任何資料檔，請先執行分析腳本${NC}"
    exit 1
fi

# 更新全球市場資料
echo -e "${YELLOW}🌐 更新全球市場資料 (Gold/Silver/Oil)...${NC}"
python3 "$PAGES_DIR/fetch_global.py" && echo -e "${GREEN}✅ global_data.json${NC}" || echo -e "${RED}⚠️  global_data.json 更新失敗（使用舊資料）${NC}"

# 寫入最新推送時間
PUSH_TS=$(date '+%Y-%m-%dT%H:%M:%S')
echo "{\"ts\":\"$PUSH_TS\",\"date\":\"$(date '+%Y/%m/%d')\",\"time\":\"$(date '+%H:%M')\"}" > "$DATA_DIR/last_push.json"
echo -e "${GREEN}✅ last_push.json ($PUSH_TS)${NC}"

# Git push
cd "$PAGES_DIR"
git add data/
git add index.html 2>/dev/null || true
git add global_data.json 2>/dev/null || true
git add fetch_global.py 2>/dev/null || true

# 只在有變更時才 commit
if git diff --staged --quiet; then
    echo -e "${YELLOW}ℹ️  資料沒有變更，跳過推送${NC}"
else
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
    git commit -m "📊 資料更新 $TIMESTAMP"
    git push origin main
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}   ✅ 推送完成！${NC}"
    echo -e "${GREEN}   🌐 https://taiwantick.github.io/taiwan-stock-radar/${NC}"
    echo -e "${GREEN}================================================${NC}"
fi
echo ""
