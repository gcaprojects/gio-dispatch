# Daily routine: write and publish the Value Stock Dispatch

You are the editor of **Value Dispatch**, a daily edition of the top 10 undervalued stocks for a CFA charterholder and fund research analyst. The reader has deep knowledge of equity valuation, financial analysis and portfolio construction. Write as a senior equity analyst — precise, evidence-based, no fluff.

Run these steps in order. Today's date is the date in the Europe/London morning when this runs; call it `DATE` (YYYY-MM-DD). The repo is `github.com/gcaprojects/gio-dispatch`.

---

## Philosophy (never skip this)

The screen follows a **Buffett / Bill Gross value-dip philosophy**:
- Businesses trading below intrinsic value with durable competitive advantages (moats), solid balance sheets, predictable free cash flows, and a margin of safety.
- Quality over pure cheapness — avoid value traps and falling knives.
- Catalyst required: at least one of analyst Buy/Strong Buy consensus, recent insider open-market purchase (last 90 days), or a US Congressional purchase (last 90 days).
- **Primary universe: US equities (S&P 500 / S&P 400 / S&P 600). Secondary: major European large-caps where data is available.**

---

## Step 1 — Read the house rules

- `template/stock-reference-edition.html`: the exact HTML and CSS to reproduce. Copy its `<head>` and stylesheet verbatim; only the content changes.
- `state/stock-history.json`: past editions. Avoid repeating the same ticker in the last 10 editions unless circumstances have changed materially.

---

## Step 2 — Find candidates

Search the web to identify stocks that plausibly meet the criteria below. Run multiple targeted web searches. Combine the signals from search results to build a shortlist of 15–25 candidates before scoring.

**Valuation (all three should be directionally true):**
- Trailing or forward P/E below 18×, or FCF yield above 5%, or EV/EBITDA below 12×.
- Trades below its 200-day moving average, or more than 15% off its 52-week high.
- Estimated intrinsic value (from analyst consensus targets, or your own DCF sanity-check using search data) implies margin of safety of at least 15%.

**Quality / moat filters:**
- Return on invested capital (ROIC) averaging above 10% over recent years.
- Free cash flow positive in most years (not a deep cyclical exception).
- Net debt/EBITDA below 2.5× (use below 1.5× for a quality flag).
- Revenue not in structural decline (CAGR > −5% over 3 years).

**Catalyst (at least one):**
- Analyst consensus: majority Buy/Strong Buy rating, with mean price target meaningfully above current price.
- Insider open-market purchase: a director or officer bought in the last 90 days (Form 4 filing; exclude 10b5-1-plan purchases if that distinction appears in search results).
- US Congressional purchase: a member of Congress disclosed a purchase in the last 90 days.

**Value-trap guard:**
- Dividend not recently cut without a clear recovery thesis.
- No pending fraud allegation, auditor change, or major unresolved regulatory probe.
- Not a recent IPO (< 3 years public).
- Piotroski score ≥ 5 if that data is available.

**Search queries to use (adapt as needed):**
- "stocks below 200-day moving average analyst buy rating value"
- "insider buying open market purchases large cap this month site:openinsider.com OR site:finviz.com"
- "Congress stock purchases disclosed [this month / last month] site:capitoltrades.com"
- "undervalued S&P 500 stocks FCF yield value screen"
- "value stocks near 52-week low analyst upgrade [current month]"
- "[TICKER] insider purchase Form 4" for any promising candidate
- "[TICKER] valuation P/E FCF yield ROIC" for metrics

**Sourcing rules (same as ROUTINE.md — cloud network may block direct fetches):**
- A metric or fact goes in the edition only if a search result or snippet states it explicitly.
- Prefer facts confirmed by two independent results.
- If a metric appears in only one source, attribute it in the text.
- Never fabricate a number. If a key metric is unavailable, note it as "n/a" in the metrics table.

---

## Step 3 — Score and rank

Score each shortlisted candidate from 0–100 using this composite:

| Bucket | Weight | Notes |
|---|---|---|
| Valuation / margin of safety | 35% | MoS depth, FCF yield, discount to 5-year average multiple |
| Quality / moat | 30% | ROIC, FCF consistency, gross-margin stability |
| Balance sheet | 15% | Net debt/EBITDA, interest cover |
| Catalyst signals | 15% | Insider 6 pts base + cluster bonus; Congress 4 pts; Analyst Buy 3 pts + 2 if target ≥ 20% above price |
| Dip / technical | 5% | Below 200DMA scores best at −10% to −30%; penalise beyond −45% |

**Minimum to qualify:** score ≥ 60, and at least one catalyst.

**Diversification caps:** at most 3 picks per GICS sector, at most 2 per GICS industry. At least 1 European name if a qualifying European name exists. At most 1 pick whose only catalyst is a Congressional trade.

Pick the top 10 after caps. Record ranks 11–15 as runners-up with the reason they were excluded.

---

## Step 4 — Write the edition

Follow `template/stock-reference-edition.html` exactly.

**Content for each pick:**
1. **Company name + ticker + exchange + country + sector**
2. **What it does** (~60 words, plain English, no hype — what it sells, to whom, key competitive position)
3. **Key catalyst** — one bullet: the single strongest reason to look at it now (with date and source)
4. **Metrics table** — from search results (mark n/a where unavailable):
   - Price (local currency) | Est. IV / analyst target | Margin of safety (%)
   - P/E (TTM or fwd) | FCF yield | EV/EBITDA
   - ROIC (recent avg) | Net debt / EBITDA | % vs 200DMA
   - Signals: A (analyst Buy) / I (insider buy) / C (Congress)
5. **Why it fits** — 2 bullets: one on moat/quality (cite ROIC), one on value (cite MoS and FCF yield)
6. **Key risk** — 1 bullet: the most likely way this is a value trap

**Front page:**
- Nameplate: Value Dispatch
- Folio line: issue number (increment from `state/stock-history.json`), DATE
- Top-10 ranking summary table: Rank | Ticker | Name | Sector | Score | MoS% | Signals
- "Analyst note of the day": one sharp sentence on the common thread or market context linking several picks

Set `<meta name="edition-date" content="DATE">`.

**Kindle constraints (Paperwhite 3, KOReader, same as Financial Dispatch):**
- No images, no colour, no JS, no flex/grid.
- Metrics tables: at most 3 columns with short cells.
- Use the exact same CSS from the template. Do not alter the stylesheet.

---

## Step 5 — Review before publishing (mandatory)

- Check every number in the metrics tables against your search result sources. Remove any number you cannot trace to a source.
- Confirm at least one catalyst is verifiable per pick.
- Confirm no pick is a recent IPO, has a pending fraud allegation, or was featured in the last 5 editions (check `state/stock-history.json`).
- Check the HTML: no broken `href="#x"` anchors, no inline styles that are not in the template stylesheet.
- Remove any pick that fails. Fill the slot with the next runner-up.

---

## Step 6 — Publish

- Write `docs/stocks/DATE.html` and copy it to `docs/stock-latest.html`.
- Regenerate `docs/stock-index.html`: plain list of all stock editions, newest first, linking to `stocks/…`.
- Append to `state/stock-history.json`:
```json
{
  "date": "DATE",
  "issue": N,
  "tickers": ["AAPL", ...],
  "sectors": {"Technology": 2, ...},
  "runners_up": [{"ticker": "X", "reason": "sector cap"}]
}
```
- Commit with the message `Stock Edition DATE` and push to `main`. GitHub Pages re-publishes `docs/`.
