#!/bin/bash
# ================================================
# push_data.sh — 推送最新資料至 GitHub Pages
# ================================================
# 使用方式：bash push_data.sh
#
# 資料來源優先順序：
#   1. stock-mcp 引擎（主要）
#   2. telegram_dashboard / stockbot（備援/補充）
# ================================================

PAGES_DIR="$(cd "$(dirname "$0")" && pwd)"
DASHBOARD_DIR="$PAGES_DIR/../telegram_dashboard"
STOCK_TW_DIR="$PAGES_DIR/.."
DATA_DIR="$PAGES_DIR/data"
STOCK_MCP_DIR="$HOME/TWstock_MCP/TWstock_MCP/stock-mcp"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}════════════════════════════════════════${NC}"
echo -e "${CYAN}  📤 Taiwan Stock Radar — 資料推送${NC}"
echo -e "${CYAN}════════════════════════════════════════${NC}"
echo ""

# ─────────────────────────────────────
# Step 1: stock-mcp 引擎生成資料（主要來源）
# ─────────────────────────────────────

MCP_OK=0

if [ -d "$STOCK_MCP_DIR" ] && [ -f "$STOCK_MCP_DIR/.venv/bin/python" ]; then
    echo -e "${YELLOW}🔬 執行 stock-mcp 分析引擎...${NC}"
    cd "$STOCK_MCP_DIR"

    .venv/bin/python scripts/export_website_data.py --output-dir "$DATA_DIR" 2>&1
    if [ $? -eq 0 ]; then
        MCP_OK=1
        echo -e "${GREEN}✅ stock-mcp 資料生成完成${NC}"
    else
        echo -e "${RED}⚠️  stock-mcp 執行失敗，使用備援資料${NC}"
    fi
    echo ""
else
    echo -e "${YELLOW}ℹ️  stock-mcp 不在此機器，使用備援來源${NC}"
fi

# ─────────────────────────────────────
# Step 2: 備援/補充資料（telegram_dashboard）
# ─────────────────────────────────────

COPIED=0

# dashboard_data.json — 如果 stock-mcp 已生成則跳過
if [ $MCP_OK -eq 0 ]; then
    DASH_SRC=""
    DASH_A="$HOME/stockbot/dashboard_data.json"
    DASH_B="$STOCK_TW_DIR/dashboard_data.json"
    if [ -f "$DASH_A" ] && [ -f "$DASH_B" ]; then
        if [ "$DASH_A" -nt "$DASH_B" ]; then DASH_SRC="$DASH_A"; else DASH_SRC="$DASH_B"; fi
    elif [ -f "$DASH_A" ]; then DASH_SRC="$DASH_A"
    elif [ -f "$DASH_B" ]; then DASH_SRC="$DASH_B"
    fi
    if [ -n "$DASH_SRC" ]; then
        cp "$DASH_SRC" "$DATA_DIR/dashboard_data.json"
        echo -e "${GREEN}  ✅ dashboard_data.json（備援：$DASH_SRC）${NC}"
        COPIED=$((COPIED+1))
    fi

    # screener / radar 備援
    for f in screener_data.json radar_data.json; do
        if [ -f "$DASHBOARD_DIR/$f" ]; then
            cp "$DASHBOARD_DIR/$f" "$DATA_DIR/"
            echo -e "${GREEN}  ✅ $f（備援）${NC}"
            COPIED=$((COPIED+1))
        fi
    done
fi

# realtime_alerts / insider — 這些目前只有 telegram_dashboard 產生，永遠補充
if [ -f "$DASHBOARD_DIR/realtime_alerts.json" ]; then
    cp "$DASHBOARD_DIR/realtime_alerts.json" "$DATA_DIR/"
    echo -e "${GREEN}  ✅ realtime_alerts.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ -f "$DASHBOARD_DIR/insider_data.json" ]; then
    cp "$DASHBOARD_DIR/insider_data.json" "$DATA_DIR/"
    echo -e "${GREEN}  ✅ insider_data.json${NC}"
    COPIED=$((COPIED+1))
fi

# kline_data
if [ -f "$DATA_DIR/kline_data.json" ]; then
    echo -e "${GREEN}  ✅ kline_data.json（已在 data/）${NC}"
    COPIED=$((COPIED+1))
elif [ -f "$DASHBOARD_DIR/kline_data.json" ]; then
    cp "$DASHBOARD_DIR/kline_data.json" "$DATA_DIR/"
    echo -e "${GREEN}  ✅ kline_data.json${NC}"
    COPIED=$((COPIED+1))
fi

if [ $MCP_OK -eq 0 ] && [ $COPIED -eq 0 ]; then
    echo -e "${RED}❌ 找不到任何資料檔，請先執行分析腳本${NC}"
    exit 1
fi

# ─────────────────────────────────────
# Step 3: 全球市場資料
# ─────────────────────────────────────

echo ""
echo -e "${YELLOW}🌐 更新全球市場資料 (Gold/Silver/Oil)...${NC}"
python3 "$PAGES_DIR/fetch_global.py" 2>/dev/null && echo -e "${GREEN}  ✅ global_data.json${NC}" || echo -e "${RED}  ⚠️  global_data.json 更新失敗（使用舊資料）${NC}"

# ─────────────────────────────────────
# Step 4: Git push
# ─────────────────────────────────────

echo ""
cd "$PAGES_DIR"
git add data/
git add index.html 2>/dev/null || true
git add global_data.json 2>/dev/null || true
git add fetch_global.py 2>/dev/null || true

if git diff --staged --quiet; then
    echo -e "${YELLOW}ℹ️  資料沒有變更，跳過推送${NC}"
else
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
    SOURCE="stock-mcp"
    [ $MCP_OK -eq 0 ] && SOURCE="legacy"
    git commit -m "📊 資料更新 $TIMESTAMP [$SOURCE]"
    git push origin main
    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}   ✅ 推送完成！[${SOURCE}]${NC}"
    echo -e "${GREEN}   🌐 https://taiwantick.github.io/taiwan-stock-radar/${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
fi
echo ""
