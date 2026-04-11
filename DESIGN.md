# Taiwan Stock Radar — DESIGN.md

> 台股智能儀表板設計規範。靈感來源：Revolut fintech dark UI。
> 供 AI coding agent 參考，確保所有頁面和元件風格一致。

---

## 1. Design Philosophy

- **精品金融感**：不是工程師 dashboard，而是現代 fintech app 的質感
- **數據密度與呼吸感並存**：大量數據但不壓迫，靠留白和層次感引導視線
- **暗色優先**：深色背景減少視覺疲勞，適合長時間盯盤
- **克制的動效**：微妙的 hover 過渡和進場動畫，不花俏
- **行動優先**：重要數字大且醒目，一眼抓到關鍵資訊

---

## 2. Color Tokens

### 2.1 Background & Surface (深色主題)

| Token | Hex | 用途 |
|---|---|---|
| `--bg` | `#22272E` | 頁面底色（深灰藍，Dark Dimmed 風格） |
| `--surface-1` | `#2D333B` | 一級卡片背景 |
| `--surface-2` | `#353C47` | 二級卡片/彈窗背景 |
| `--surface-3` | `#3D4550` | hover 狀態、輸入框背景 |
| `--surface-elevated` | `#323940` | 浮動元素（modal、dropdown） |

### 2.2 Border & Divider

| Token | Hex | 用途 |
|---|---|---|
| `--border-subtle` | `#444C56` | 卡片邊框（清晰可見的灰色） |
| `--border-default` | `#505962` | 表格分隔線、輸入框邊框 |
| `--border-hover` | `#636E7B` | hover 時的邊框高亮 |
| `--divider` | `#3D4550` | 區塊間分隔線 |

### 2.3 Text

| Token | Hex | 用途 |
|---|---|---|
| `--text-primary` | `#DADEE6` | 主文字（標題、數字） |
| `--text-secondary` | `#8B949E` | 副文字（說明、標籤） |
| `--text-tertiary` | `#6E7A86` | 最淡文字（備註、時間戳） |
| `--text-on-accent` | `#FFFFFF` | 在強調色背景上的文字 |

### 2.4 Accent Colors

| Token | Hex | 用途 |
|---|---|---|
| `--accent-primary` | `#6C72FF` | 主品牌色（矢車菊藍紫） |
| `--accent-primary-hover` | `#7F84FF` | 主品牌色 hover |
| `--accent-primary-muted` | `rgba(108,114,255,0.12)` | 主品牌色淡底（badge、tag） |
| `--accent-secondary` | `#3DD6C8` | 輔助色（薄荷綠，保留台灣意象） |
| `--accent-secondary-muted` | `rgba(61,214,200,0.10)` | 輔助色淡底 |

### 2.5 Semantic Colors

| Token | Hex | 用途 |
|---|---|---|
| `--positive` | `#2DD57A` | 漲、買超、正向訊號 |
| `--positive-muted` | `rgba(45,213,122,0.12)` | 正向淡底 |
| `--negative` | `#F5475B` | 跌、賣超、風險警告 |
| `--negative-muted` | `rgba(245,71,91,0.10)` | 負向淡底 |
| `--warning` | `#FFAA2B` | 注意、中性訊號 |
| `--warning-muted` | `rgba(255,170,43,0.10)` | 警告淡底 |
| `--info` | `#4DA3FF` | 資訊提示 |

### 2.6 Gradient

```css
/* 主品牌漸層 — 用於 hero badge、CTA 按鈕 */
--gradient-brand: linear-gradient(135deg, #6C72FF 0%, #3DD6C8 100%);

/* 卡片亮點漸層 — 用於高分股票卡片邊框 */
--gradient-highlight: linear-gradient(135deg, rgba(108,114,255,0.3) 0%, rgba(61,214,200,0.15) 100%);

/* 表面微漸層 — 用於 header、footer */
--gradient-surface: linear-gradient(180deg, #22272E 0%, #282E36 100%);
```

---

## 3. Typography

### 3.1 Font Stack

```css
--font-primary: 'Inter', 'Noto Sans TC', -apple-system, 'SF Pro Display', 'Segoe UI', sans-serif;
--font-mono: 'JetBrains Mono', 'SF Mono', 'Menlo', monospace;
```

> Inter 處理英數，Noto Sans TC 處理中文。兩者 x-height 接近，混排協調。

### 3.2 Type Scale

| Level | Size | Weight | Letter Spacing | 用途 |
|---|---|---|---|---|
| Display | 2.5rem (40px) | 700 | -0.02em | 頁面主標題（極少用） |
| H1 | 1.75rem (28px) | 700 | -0.015em | 區塊大標題 |
| H2 | 1.25rem (20px) | 600 | -0.01em | 卡片標題 |
| H3 | 1rem (16px) | 600 | 0 | 子區塊標題 |
| Body | 0.875rem (14px) | 400 | 0 | 正文 |
| Caption | 0.75rem (12px) | 400 | 0.01em | 標籤、時間戳、備註 |
| Overline | 0.68rem (11px) | 600 | 0.06em | 全大寫標籤（EN）/ 小型標籤 |
| Mono | 0.875rem (14px) | 500 | 0.02em | 數字、代碼、價格 |

### 3.3 Number Display

- 股票代號：`--font-mono`, weight 600, color `--accent-primary`
- 價格/金額：`--font-mono`, weight 700, tabular-nums
- 百分比漲跌：`--font-mono`, weight 600, 正值用 `--positive` + 前綴 `+`，負值用 `--negative`
- 評分數字：`--font-primary`, weight 800, size 1.5rem+

---

## 4. Spacing & Layout

### 4.1 Spacing Scale (8px base)

| Token | Value | 用途 |
|---|---|---|
| `--space-1` | 4px | 最小間距（icon 與文字） |
| `--space-2` | 8px | 緊湊間距 |
| `--space-3` | 12px | 元素內 padding |
| `--space-4` | 16px | 卡片內 padding |
| `--space-5` | 24px | 區塊間距 |
| `--space-6` | 32px | Section 間距 |
| `--space-8` | 48px | 大區塊間距 |

### 4.2 Layout

```
Max content width: 1200px (居中)
Side padding: 24px (desktop) / 16px (mobile)
Card grid gap: 16px
Section gap: 32px
```

### 4.3 Grid

- **KPI 卡片列**：3 欄（desktop）→ 2 欄（tablet）→ 1 欄（mobile）
- **股票卡片**：auto-fill, minmax(300px, 1fr)
- **圖表區**：2 欄（desktop）→ 1 欄（mobile）
- **表格**：100% 寬度，水平滾動（mobile）

---

## 5. Border Radius

| Token | Value | 用途 |
|---|---|---|
| `--radius-sm` | 6px | 小元素（tag、badge） |
| `--radius-md` | 12px | 卡片、輸入框 |
| `--radius-lg` | 16px | 大卡片、modal |
| `--radius-xl` | 24px | 按鈕（pill shape） |
| `--radius-full` | 9999px | 圓形頭像、dot indicator |

---

## 6. Elevation & Shadow

```css
/* 不使用傳統 box-shadow，改用 border + 背景色差 分層 */
/* Revolut 風格：扁平層次，靠色差而非陰影 */

--shadow-card: none;  /* 卡片無陰影，靠 surface 色差 */
--shadow-elevated: 0 8px 32px rgba(0,0,0,0.4);  /* 僅 modal/dropdown */
--shadow-glow: 0 0 20px rgba(108,114,255,0.15);  /* 品牌色光暈，特殊強調用 */
```

---

## 7. Components

### 7.1 Card（核心元件）

```css
.card {
  background: var(--surface-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-md);
  padding: var(--space-4) var(--space-5);
  transition: border-color 0.2s ease, background 0.2s ease;
}
.card:hover {
  border-color: var(--border-hover);
  background: var(--surface-2);
}
```

- 無陰影，靠 border-subtle 區分
- Hover 時邊框微亮 + 背景微提
- 高分/重點卡片可加 `border-left: 3px solid var(--accent-primary)`

### 7.2 Badge / Tag

```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  border-radius: var(--radius-xl);
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.02em;
}
.badge-primary {
  background: var(--accent-primary-muted);
  color: var(--accent-primary);
}
.badge-positive {
  background: var(--positive-muted);
  color: var(--positive);
}
```

### 7.3 Button

```css
.btn-primary {
  background: var(--gradient-brand);
  color: var(--text-on-accent);
  border: none;
  border-radius: var(--radius-xl);
  padding: 10px 24px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.1s;
}
.btn-primary:hover {
  opacity: 0.9;
}
.btn-primary:active {
  transform: scale(0.98);
}

.btn-ghost {
  background: transparent;
  color: var(--text-secondary);
  border: 1px solid var(--border-default);
  border-radius: var(--radius-sm);
  padding: 6px 14px;
  font-size: 0.8rem;
  transition: all 0.18s;
}
.btn-ghost:hover {
  border-color: var(--accent-primary);
  color: var(--accent-primary);
}
.btn-ghost.active {
  background: var(--accent-primary);
  color: var(--text-on-accent);
  border-color: var(--accent-primary);
}
```

### 7.4 Table

```css
.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.8rem;
}
.data-table th {
  color: var(--text-tertiary);
  font-weight: 500;
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 10px 12px;
  border-bottom: 1px solid var(--border-default);
  text-align: left;
}
.data-table td {
  padding: 10px 12px;
  border-bottom: 1px solid var(--border-subtle);
  color: var(--text-primary);
}
.data-table tr:hover td {
  background: var(--surface-2);
}
.data-table tr:last-child td {
  border-bottom: none;
}
```

- 表頭全大寫、最小字號、最淡色
- 分隔線用 border-subtle
- Hover 整行微亮

### 7.5 KPI Card

```css
.kpi-card {
  background: var(--surface-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-md);
  padding: 20px 24px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.kpi-label {
  font-size: 0.72rem;
  color: var(--text-tertiary);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.kpi-value {
  font-size: 2rem;
  font-weight: 800;
  color: var(--text-primary);
  font-variant-numeric: tabular-nums;
}
.kpi-sub {
  font-size: 0.75rem;
  color: var(--text-secondary);
}
```

### 7.6 Stock Card（觀察清單用）

```css
.stock-card {
  background: var(--surface-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-md);
  padding: 14px 18px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: border-color 0.2s;
}
.stock-card:hover {
  border-color: var(--accent-primary);
}
/* 高分卡片左邊亮線 */
.stock-card[data-quality="A"] {
  border-left: 3px solid var(--positive);
}
.stock-card[data-quality="B"] {
  border-left: 3px solid var(--accent-primary);
}
```

### 7.7 Score Badge

```css
.score-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
  padding: 4px 10px;
  border-radius: var(--radius-sm);
  font-size: 0.82rem;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}
/* A 級 (80+): 綠色 */
.score-a { background: var(--positive-muted); color: var(--positive); }
/* B 級 (60-79): 藍紫 */
.score-b { background: var(--accent-primary-muted); color: var(--accent-primary); }
/* C 級 (40-59): 黃色 */
.score-c { background: var(--warning-muted); color: var(--warning); }
/* D 級 (<40): 灰色 */
.score-d { background: rgba(92,102,120,0.12); color: var(--text-tertiary); }
```

### 7.8 Alert Type Tag

```css
.alert-tag {
  padding: 3px 8px;
  border-radius: var(--radius-sm);
  font-size: 0.68rem;
  font-weight: 600;
}
.alert-breakout { background: var(--positive-muted); color: var(--positive); }
.alert-breakdown { background: var(--negative-muted); color: var(--negative); }
.alert-entry { background: var(--accent-secondary-muted); color: var(--accent-secondary); }
.alert-target { background: var(--warning-muted); color: var(--warning); }
.alert-volatility { background: var(--accent-primary-muted); color: var(--accent-primary); }
```

### 7.9 Header

```css
header {
  background: var(--gradient-surface);
  border-bottom: 1px solid var(--border-subtle);
  padding: 16px 24px;
  position: sticky;
  top: 0;
  z-index: 100;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}
```

### 7.10 Section Header

```
[Badge 標籤]  描述文字                              更新時間
```

- Badge 用品牌漸層底或 accent-muted 底
- 描述文字用 text-secondary
- 更新時間靠右，text-tertiary

---

## 8. Animation & Transition

```css
/* 基礎過渡 */
--transition-fast: 0.15s ease;
--transition-normal: 0.2s ease;
--transition-slow: 0.35s ease;

/* 進場動畫（卡片載入） */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
.card { animation: fadeInUp 0.3s ease both; }

/* Pulse（live indicator） */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}
```

---

## 9. Responsive Breakpoints

| Breakpoint | Width | 調整 |
|---|---|---|
| Desktop | > 1024px | 全功能，多欄佈局 |
| Tablet | 641-1024px | KPI 2 欄，圖表 1 欄 |
| Mobile | ≤ 640px | 單欄，表格水平滾動，padding 縮小 |

```css
@media (max-width: 1024px) {
  /* KPI: 3 → 2 col */
  /* Chart grid: 2 → 1 col */
}
@media (max-width: 640px) {
  /* KPI: 2 → 1 col */
  /* Side padding: 24px → 16px */
  /* 隱藏非必要的副文字 */
}
```

---

## 10. Do's and Don'ts

### ✅ Do

- 數字用等寬字型（tabular-nums），確保對齊
- 漲跌一律帶 `+` / `-` 前綴和顏色
- 卡片分層靠背景色差，不靠陰影
- 重點數據放大（評分、價格），一眼看到
- 保持暗色主題的對比度（WCAG AA 以上）
- 留白充足，Section 間至少 32px

### ❌ Don't

- 不要在暗色背景上用純白邊框（太刺眼）
- 不要超過 3 種強調色同時出現
- 不要用 box-shadow 做卡片分層（Revolut 風格用色差）
- 不要在小空間塞太多按鈕/操作
- 不要用彩虹色漸層（保持冷色調一致性）
- 不要在表格裡用太多 badge（最多 1-2 欄有色塊）

---

## 11. Brand Identity

- **名稱**：台股智能儀表板 / Taiwan Stock Radar
- **Logo**：📊（暫用 emoji，未來可換 SVG）
- **Tagline**：
  - ZH: 讓世界投資台灣
  - EN: Let the world invest in Taiwan
- **品牌色系**：矢車菊藍紫 (`#6C72FF`) + 薄荷綠 (`#3DD6C8`)
  - 藍紫代表科技/金融專業
  - 薄荷綠保留台灣意象（原有的綠色系延伸）
