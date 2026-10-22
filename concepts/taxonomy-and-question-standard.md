# The Plumbing Dispatch: CFA professor's design (v1)

## 1. Concept taxonomy (54 concepts)

Each concept has an ID, a one-line "core claim" (stored in the taxonomy file, used by the reviewer as ground truth), and a difficulty tier (1 = CFA L2, 2 = L3 / practitioner, 3 = desk-level).

- **Rates / fixed income (FI):** FI-DURATION (modified vs Macaulay vs effective), FI-CONVEXITY, FI-KEYRATE (key-rate duration, curve shape risk), FI-CARRY-ROLL, FI-TERMPREM (term premium vs expected path), FI-REPO (GC vs specials, haircuts), FI-BASIS (cash-futures basis, CTD, implied repo), FI-SWAPSPREAD, FI-INFLATION (breakevens, linker carry, index lag), FI-MBS-NEGCONVEX.
- **Credit and private credit (CR):** CR-SPREADS (OAS, Z-spread, spread duration), CR-DEFAULT-LGD, CR-COVENANT (cov-lite, EBITDA add-backs), CR-LME (liability management: uptiers, drop-downs, non-pro-rata exchanges), CR-PIK (PIK toggles, "bad PIK" vs structured PIK), CR-NONACCRUAL, CR-CLO (waterfall, OC/IC tests, CCC buckets), CR-BDC (NAV discount, RIC distribution, asset coverage), CR-NAVFAC (NAV facilities, GP-level leverage), CR-MARKLAG (Level 3 marks, smoothing).
- **Derivatives (DV):** DV-FWD-PARITY (cost of carry, covered interest parity), DV-XCCY-BASIS, DV-SWAP-VAL, DV-GREEKS (delta/gamma/vega, dealer gamma positioning), DV-VOLSURFACE (skew, term structure, VIX construction), DV-CDS (CDS-bond basis, auction, index roll), DV-MARGIN (VM vs IM, procyclicality, CCP waterfalls).
- **Equity / valuation (EQ):** EQ-ERP (implied ERP, earnings yield vs real yield), EQ-BUYBACK (EPS accretion vs value creation), EQ-INDEX (rebalancing flows, concentration), EQ-FACTOR (crowding, momentum crashes), EQ-DCF-RATE (long-duration equity sensitivity).
- **Alternatives and fund structures (AL):** AL-PE-SECONDARIES (LP-led, GP-led continuation vehicles, pricing to NAV), AL-JCURVE-IRR (IRR vs TVPI/DPI, subscription-line flattering), AL-SUBLINE, AL-EVERGREEN (semi-liquid funds, NAV-based subscriptions/redemptions), AL-GATES (gates, suspensions, side pockets), AL-HF-PODS (multi-manager pass-through fees, netting risk), AL-REIT-NAV (listed vs private real estate marks, cap-rate maths), AL-INFRA.
- **Market structure and liquidity (MS):** MS-DEALER-BS (balance sheet constraints), MS-ETF-ARB (creation/redemption, bond ETF discounts), MS-FIRE-SALE (forced selling, liquidity spirals), MS-TREASURY-CLEARING (central clearing mandate), MS-MMF (prime vs govt, liquidity fees).
- **Macro / central-bank plumbing (CB):** CB-RESERVES (reserve scarcity, ON RRP drain), CB-QT, CB-SRF (standing repo facility, SOFR spikes), CB-SLR (leverage ratios, Treasury exemption), CB-FX-INTERVENTION, CB-TRANSMISSION (policy rate to mortgage/corporate rates, floating-rate pass-through).
- **Risk and performance measurement (RP):** RP-VAR-ES, RP-ATTRIBUTION (Brinson, fixed-income attribution), RP-SHARPE-SMOOTHING (autocorrelation, unsmoothing), RP-TRACKING-ERROR, RP-DRAWDOWN-LIQ (liquidity-adjusted risk).
- **Fund due diligence (DD):** DD-LIQ-MISMATCH (asset vs liability liquidity, redemption terms), DD-VALUATION-GOV (independent valuation, pricing committees), DD-FEES (hurdles, catch-up, crystallisation, high-water marks), DD-LEVERAGE (fund vs portfolio-company vs GP leverage), DD-STYLE-DRIFT.

**News trigger → concept mapping (the generator's lookup table; extend as you go):**

| Trigger | Primary concepts |
|---|---|
| Private credit stress / BDC results | CR-PIK, CR-NONACCRUAL, CR-BDC, CR-MARKLAG, AL-GATES, CR-NAVFAC |
| Treasury sell-off / auction tail | FI-BASIS, FI-SWAPSPREAD, CB-SLR, FI-TERMPREM, MS-DEALER-BS |
| Repo rate spike / month-end funding | CB-RESERVES, CB-SRF, FI-REPO, CB-QT |
| Central bank decision | CB-TRANSMISSION, FI-KEYRATE, DV-FWD-PARITY, FI-TERMPREM |
| Distressed exchange / bankruptcy | CR-LME, CR-COVENANT, CR-DEFAULT-LGD, DV-CDS |
| Vol spike / equity crash day | DV-GREEKS, DV-VOLSURFACE, DV-MARGIN, EQ-FACTOR, AL-HF-PODS |
| Semi-liquid / evergreen fund redemptions | AL-EVERGREEN, AL-GATES, DD-LIQ-MISMATCH, CR-MARKLAG |
| GP-led secondary / continuation fund | AL-PE-SECONDARIES, AL-JCURVE-IRR, DD-FEES |
| Real estate fund marks, CRE loans | AL-REIT-NAV, CR-MARKLAG, RP-SHARPE-SMOOTHING |
| Yen / dollar funding moves | DV-XCCY-BASIS, DV-FWD-PARITY, CB-FX-INTERVENTION |
| CLO issuance / downgrades | CR-CLO, CR-SPREADS, CR-COVENANT |
| Bond ETF discount in a sell-off | MS-ETF-ARB, MS-FIRE-SALE |
| Index rebalance / mega-cap concentration | EQ-INDEX, RP-TRACKING-ERROR, EQ-FACTOR |
| Regulatory rule (SEC, Basel, clearing) | MS-TREASURY-CLEARING, CB-SLR, MS-MMF |

## 2. Story selection rubric

Score each candidate headline 0–3 on five criteria; the maximum total is 15. Admit a story only if it scores at least 9.

1. **Mechanism depth.** Can a non-obvious causal chain of two or more steps be explained? (A happened because of B, through C.)
2. **Taxonomy hit.** Does it map to at least one concept, ideally tier 2 or 3?
3. **Fund-analyst relevance.** Would it change a question asked of a manager?
4. **Quantifiability.** Is there a formula or a calculation that teaches something?
5. **Factual anchor.** Does the source state the key facts clearly, with dates, figures and entities? A low score here means the story risks invented detail.

**Hard rejects:** pure price moves ("S&P up 1%") with no identified cause; politics with no transmission channel; M&A gossip; personality stories; single-stock earnings with no structural angle; anything whose only source is a paywalled headline with no body text (risk of fabrication).

**Diversity constraint:** the 3 stories must come from 3 different areas. No more than one story from macro/rates on a central-bank day, and at least one story from credit, alternatives or due diligence (the reader's day job). Concepts used in the last 10 days get a −3 penalty unless the spaced-repetition scheduler has flagged them as due.

## 3. Article template (about 550–700 words per story)

- **Headline** (≤ 10 words, a factual statement, not a pun).
- **The News** (60–90 words). Who, what, when, and the source name. Only facts from the source. No adjectives the source didn't use.
- **The Plumbing** (250–350 words). The causal chain, written as numbered steps. Include a formula when the mechanism is quantitative (duration, basis, coverage ratios, NAV discount maths, carry). Include a **worked number example** when a ratio or sensitivity would be misjudged by intuition, for example when leverage amplifies an effect, a sign is counterintuitive, or there is convexity. Keep it to a single box of 3–5 lines.
- **Why it matters for a fund analyst** (80–120 words). 2–3 concrete DD questions or portfolio checks, phrased as you would ask them on a manager call.
- **Interview line** (≤ 35 words). One sentence that shows you understand the mechanism, not that you read the news.
- **Drill** (3 questions, explanations of 60–100 words each).

## 4. Question design standard

**Bloom mix per story:** at most 1 "remember/understand" question. At least 1 "apply" question (a calculation or applying a rule to a new case) and at least 1 "analyse/evaluate" question (diagnose a situation, choose the best DD action, rank risks). Do not ask about a news fact (dates, names, amounts). Questions test the mechanism, so they stay valid after the news is forgotten.

**Format:** 4 options, A–D, one unambiguously correct. Keep options similar in length. No "all of the above". No negatives unless the NOT is in bold.

**Distractors must encode real misconceptions.** Each distractor gets a tag from a fixed list: `sign-error`, `ignores-leverage`, `wrong-denominator`, `confuses-accrual-with-cash`, `cost-vs-fair-value`, `price-vs-yield`, `true-but-irrelevant`, `partial-mechanism`, `textbook-not-practice`. Repeated misses on the same tag drive remediation (see §5).

**Explanation format:** (1) the correct answer, in one sentence with the reasoning; (2) for each distractor, one line: "Tempting because… / wrong because…"; (3) the concept ID(s).

### Worked example

**Headline:** BDC non-accruals rise as PIK income climbs (illustrative composite; not a real filing)

**The News.** *(In production this comes only from the source. Here it is a hypothetical composite.)* A listed business development company reported a quarter in which loans on non-accrual rose, the share of investment income paid in kind increased, and the shares traded at a widening discount to reported NAV.

**The Plumbing.**
1. A BDC is a closed-end vehicle that lends to middle-market companies. It elects RIC tax status, so it must distribute at least 90% of its investment company taxable income. The 1940 Act asset-coverage test (150% after the 2018 SBCAA election) caps leverage at about 2.0x debt/equity.
2. Stressed borrowers often switch cash coupons to **PIK**: interest accrues by increasing the principal. The BDC still books PIK as income, so net investment income (NII) holds up, but no cash comes in. PIK also counts as taxable income, so it has to be distributed in cash.
3. When collection becomes doubtful, the loan goes on **non-accrual**: income recognition stops. Non-accruals are reported **at cost and at fair value**. Fair value is already marked down, so the fair-value figure always looks smaller.
4. Marks are Level 3 (model-based, updated quarterly). The listed price reprices daily, so the **price/NAV discount** is the market's estimate of the gap between marks and reality, net of fee drag.

*Worked example (illustrative numbers):* NII = $100m, of which PIK = $20m. Dividend = $95m. Headline coverage = 100/95 = **105%**. Cash coverage = 80/95 = **84%**.
NAV/share = $20.00, price = $17.00, so the discount is 15%. With debt/equity of 1.1x, assets/share = $42. Closing the discount through marks requires a $3 hit, which is 3/42 = **7.1% of assets**.

**Why it matters.** Ask for non-accruals at cost *and* at fair value, and how both have moved over several quarters. Ask for PIK as a % of total investment income, split into PIK negotiated at origination and PIK switched on through amendment. Ask how many loans were amended or extended in the last 12 months. Ask for the share of marks that were reviewed by a third-party valuer.

**Interview line:** "In a BDC, I look through NII to cash NII and non-accruals at cost. PIK and fair-value reporting can make a stressed book look covered for several quarters."

**Q1 (Apply).** A BDC has NAV of $20.00/share, a share price of $17.00 and debt/equity of 1.1x. Ignoring fees and taxes, roughly what uniform markdown of portfolio assets would justify the price?
A) 15.0% B) 13.6% C) 7.1% D) 31.5%
**Answer: C.** Equity is $20 and assets are $42 per share, so a $3 equity loss is 3/42 ≈ 7.1% of assets. Leverage makes the implied asset markdown much smaller than the discount.
A, `ignores-leverage`: treats the equity discount as the asset loss.
B, `wrong-denominator`: 15%/1.1 divides by debt/equity instead of assets/equity (2.1).
D, `wrong-denominator` (inverted): multiplies by 2.1 instead of dividing. *[CR-BDC, DD-LEVERAGE]*

**Q2 (Understand → Apply).** NII is $100m, PIK income is $20m and the dividend is $95m. Which statement is most accurate?
A) The dividend is covered 105%, so it is sustainable.
B) Cash coverage is about 84%. The gap must be funded by repayments, borrowing or asset sales, and PIK still raises the RIC distribution requirement.
C) PIK income is excluded from taxable income, so it does not affect the distribution requirement.
D) PIK income is excluded from NII under GAAP, so coverage is understated.
**Answer: B.** (100 − 20)/95 ≈ 84%. PIK is accrued income for both GAAP and tax, so it inflates NII and the distribution obligation without bringing in cash.
A, `confuses-accrual-with-cash`.
C and D, `textbook-not-practice`: both get the accounting treatment wrong. *[CR-PIK, CR-BDC]*

**Q3 (Evaluate).** A manager says non-accruals are "only 1.5% of the portfolio". What is the best next question to test whether credit stress is understated?
A) How does 1.5% compare with the peer median at fair value?
B) What are non-accruals at cost, and what share of income is PIK switched on by amendment?
C) What is the fund's asset coverage ratio?
D) What is the leveraged-loan index default rate?
**Answer: B.** Fair-value non-accruals are net of markdowns. Cost basis and amendment-driven PIK show stress before it reaches non-accrual.
A, `cost-vs-fair-value`: the peer comparison has the same bias.
C, `true-but-irrelevant`: leverage matters, but it doesn't test the claim.
D, `partial-mechanism`: the broadly syndicated loan market differs from direct lending in borrower size and documentation. *[CR-NONACCRUAL, CR-MARKLAG, DD-VALUATION-GOV]*

## 5. Spaced repetition

- **Unit = concept, not question.** Each concept keeps a state: ease (starting at 2.5), interval in days, last-seen date, miss count, and misconception-tag counts.
- **Schedule (simplified SM-2):** correct → interval × ease (first interval 3 days, then 7, then about 16). Wrong → interval reset to 1 day and ease −0.2 (floor 1.3).
- **Daily slot:** 3 news stories plus **one "Back Page" review question** for the most overdue concept. The review question should be *newly generated* on that concept (a different number or framing), so the reader can't answer from memory of the old question. If today's news naturally hits an overdue concept, the scorer gives that story +3.
- **Misconception remediation:** if a tag (e.g. `ignores-leverage`) is missed twice in 14 days, the next edition's Back Page is a short cross-concept explainer on that error with one question.
- **Persistence:** the KOReader plugin stores the state locally. The generator needs it, so the plugin should upload a small JSON when it syncs, or the reader exports it weekly. Without that, scheduling has to be purely client-side: the edition ships a bank of 5–10 review questions and the plugin picks among them.

## 6. Accuracy guardrails (reviewer pass checklist)

The reviewer is a separate LLM call with a skeptical prompt. It receives the source text, the draft, and the taxonomy "core claims". It must:

1. **Recompute every number** in worked examples and answer keys, step by step. Any mismatch is a hard fail.
2. **Check sign conventions:** price vs yield direction; long/short duration; payer vs receiver swap; positive vs negative basis definitions (state which: futures − cash or cash − futures); swap spread = swap rate − Treasury yield; a discount expressed as a positive number.
3. **Check formula correctness** against the core claims (modified duration = Macaulay/(1+y/k); the convexity term carries ½; and so on). Units: bp vs %; annualised vs periodic.
4. **Check answer key uniqueness:** the reviewer answers the question blind, before seeing the key. If it disagrees, or two options are defensible, the question is rewritten. No distractor may be "true but less true" unless the stem says "most accurate" or "best".
5. **No invented facts:** every entity, figure and date in "The News" must appear in the source text. Anything else is deleted. The Plumbing may not attribute numbers to the named firm.
6. **Regulatory claims are dated:** rules change (SLR reform, clearing deadlines, Basel endgame), so phrase them as "as of [source date]" and flag them for human spot-check.
7. **Illustrative labelling:** every hypothetical number sits inside a box headed *"Illustrative numbers"*. Use round figures that are clearly not real (e.g. $100m, $20.00 NAV). Never mix a real reported figure with hypothetical ones in the same calculation.

If the reviewer fails a story twice, drop it and promote the next-ranked candidate. Log every failure so prompts can be tuned.

## 7. News sources

**Free and machine-friendly (primary facts):**
- Federal Reserve press releases, FOMC statements, H.4.1 and H.8 releases (RSS); NY Fed reference rates and repo/RRP operations (API/RSS); Treasury auction results (TreasuryDirect, Fiscal Data API).
- ECB, BoE and BoJ press releases (RSS); BIS speeches and Quarterly Review; IMF GFSR/blog; FSB reports.
- SEC press releases and **EDGAR full-text search / RSS** for 8-K, 10-Q (BDC filings), N-PORT and N-CEN. This is ideal for private credit stories because the figures are primary and public.
- OFR (Short-term Funding Monitor), FRED (data context), and CFTC Commitments of Traders.
- Fed and ECB financial stability reviews (semi-annual, rich in mechanisms).

**Headline feeds (signal, not substance):** Reuters and FT headline RSS feeds, Bloomberg's free pages, and CNBC/MarketWatch RSS. Most bodies are paywalled. Use them to *detect* topics, then anchor the facts in a primary or free source. If there is no accessible body text, the story fails criterion 5.

**Trade/blog sources with free tiers:** Liberty Street Economics (NY Fed), FEDS Notes, PitchBook/LCD free news, the 9fin and Octus free articles, and the SIFMA research pages. Check each one's terms.

**Licensing:** summarise in your own words, keep no quoted text from paywalled outlets (at most a short attributed phrase), always name and link the source, never republish full articles or charts, and keep the generated editions private (a GitHub Pages repo is public by default, so use an unlisted or private host or put it behind authentication). Check RSS terms of use: many allow personal, non-commercial use only.
