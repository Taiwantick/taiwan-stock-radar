#!/bin/bash
# ================================================
# push_radar.sh — 盤中每 15 分鐘輕量推送大單記錄
# 只推 realtime_alerts.json，速度快、不影響盤後流程
#
# 設定 crontab（盤中時段自動執行）：
#   crontab -e
#   */15 9-13 * * 1-5 bash ~/Stock_TW/github_pages/push_radar.sh >> ~/Stock_TW/logs/push_radar.log 2>&1
# ================================================

PAGES_DIR="$(cd "$(dirname "$0")" && pwd)"
DASHBOARD_DIR="$PAGES_DIR/../telegram_dashboard"
DATA_DIR="$PAGES_DIR/data"
LOG_PREFIX="[$(date '+%Y-%m-%d %H:%M:%S')]"

# 只在盤中時段執行（週一到週五 09:00–13:30）
HOUR=$(date +%H)
MIN=$(date +%M)
DOW=$(date +%u)  # 1=Mon ... 7=Sun
NOW_MINS=$((10#$HOUR * 60 + 10#$MIN))

if [ "$DOW" -gt 5 ]; then
    echo "$LOG_PREFIX ⏸ 非交易日，略過"
    exit 0
fi

OPEN_MINS=$((9 * 60))       # 09:00
CLOSE_MINS=$((13 * 60 + 35)) # 13:35

if [ "$NOW_MINS" -lt "$OPEN_MINS" ] || [ "$NOW_MINS" -gt "$CLOSE_MINS" ]; then
    echo "$LOG_PREFIX ⏸ 非盤中時段（$HOUR:$MIN），略過"
    exit 0
fi

# 複製 realtime_alerts.json
SRC="$DASHBOARD_DIR/realtime_alerts.json"
if [ ! -f "$SRC" ]; then
    echo "$LOG_PREFIX ⚠️  找不到 realtime_alerts.json，略過"
    exit 0
fi

cp "$SRC" "$DATA_DIR/realtime_alerts.json"

# 更新 last_push.json（記錄推送時間）
PUSH_TS=$(date '+%Y-%m-%dT%H:%M:%S')
echo "{\"ts\":\"$PUSH_TS\",\"date\":\"$(date '+%Y/%m/%d')\",\"time\":\"$(date '+%H:%M')\"}" > "$DATA_DIR/last_push.json"

# Git push
cd "$PAGES_DIR"
git add data/realtime_alerts.json data/last_push.json

if git diff --staged --quiet; then
    echo "$LOG_PREFIX ℹ️  大單資料無變更，略過推送"
    exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
git commit -m "📡 大單更新 $TIMESTAMP"
git push origin main

echo "$LOG_PREFIX ✅ 盤中大單推送完成"
