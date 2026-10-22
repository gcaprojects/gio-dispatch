# The Plumbing Dispatch: merged spec (v1)

*A daily KOReader edition for a CFA charterholder and fund research analyst. Each day it covers 3 news stories, explains the mechanism underneath each one, and ends with an interview-grade drill.*

This file merges the four working documents. The details live in:
[01 concept](01-concept-draft.md) · [02 CFA professor](02-cfa-professor.md) · [03 KOReader architecture](03-koreader-architecture.md) · [04 UI design](04-ui-design.md) · [05 sample edition](05-sample-edition.html)

---

## 1. What you get each morning
1. Open KOReader, then go to **Tools → Plumbing Dispatch → Today's edition**.
2. The plugin connects to Wi-Fi, downloads today's EPUB, turns Wi-Fi off again and opens the EPUB as a normal book.
3. **Front page:** the masthead, the date, and an index of 3 stories from 3 different areas. At least one story is always from credit, alternatives or fund due diligence.
4. **Each story** has 5 parts. *The News* is a short factual summary. *The Plumbing* explains the mechanism, with plain-text formulas and a worked example whose numbers are marked as illustrative. *Why it matters for a fund analyst* says what to ask a manager. *Interview line* is one sentence you could say in an interview. *Drill* is 3 multiple-choice questions.
5. **Answers page:** each question links to its answer and back, so checking an answer takes 2 taps. Every wrong option comes with the misconception that makes it tempting.
6. **Back Page:** one review question on the concept you are most overdue to revisit.
7. Optionally, the plugin also runs a **native quiz** (tap A–D, then read the explanation) and saves your results on the Kindle.

## 2. Decisions made
| Topic | Decision | Why |
|---|---|---|
| Delivery | A hybrid: the plugin downloads an EPUB and opens it in the normal reader, and a native quiz runs from JSON | KOReader's own reader gives the best typography. The EPUB carries the questions too, so the edition still works if the plugin breaks after a KOReader update |
| Fallback | An OPDS feed on the same host | You can still get the edition with no plugin code at all |
| Kindle stock browser | Dropped | Poor rendering and no offline reading |
| Content engine | A **scheduled Claude Code task** (cloud routine, daily at about 06:00) on your Claude subscription. It searches the web for news, then runs **select → write → review**, checks the output against the schema, builds the EPUB and commits it to the repo, which republishes on GitHub Pages | No API key or separate bill; it uses your plan's usage allowance. Fallback: Claude Code's GitHub Action with a subscription token from `claude setup-token` |
| Story selection | 5 criteria scored 0–3 each; a story needs at least 9/15 to be used, and pure price moves are rejected. The "taxonomy hit" criterion from [02](02-cfa-professor.md) is replaced by **"concept grounding"**: a story either maps to a known concept or defines a well-sourced new one | Every story has to carry a real mechanism, whether or not the concept is already on the list |
| Concepts | **Open-ended.** The 54 concepts in [02](02-cfa-professor.md) are a starting set, not a limit (see §2a) | Markets evolve, and so should the curriculum |
| Questions | At least 1 "apply" and 1 "analyse/evaluate" question per story. They never test news facts. Each wrong option is tagged with a named misconception | Questions stay valid in later review, and repeated misses point to a concrete weakness |
| Accuracy | The reviewer recomputes every number, answers each question blind to confirm only one answer works, and deletes any news fact not found in the source text | Wrong answer keys are the main way this product fails |
| Spaced repetition | **v1 works on the device only.** It uses a simplified SM-2 over concept IDs, and the Back Page draws from the local bank of past questions. **v2** uploads results to a private repo with a token scoped to that one repo, so the generator can write *new* questions on weak concepts | This reconciles the professor (who wants freshly written questions) with the plugin expert (who wants no sync at first) |
| Look | Old broadsheet: a Caslon/Garamond-style serif, then Noto Serif, hairline rules, small-caps kickers, no images; formulas in Unicode plain text | E-ink friendly and fully supported by crengine, KOReader's renderer |
| Night mode | Use KOReader's own inversion | No colour work needed |

## 2a. An open, growing concept registry
- The concept list lives in `generator/concepts.yaml` in the repo. It starts with the 54 starter concepts, and the daily task adds to it over time.
- When a story's mechanism isn't on the list, the writer **proposes a new concept**: an ID, the area it belongs to (a new area is allowed, e.g. `EM-` for emerging), a one-line *core claim*, and 2+ primary sources. Examples: stablecoin reserve plumbing, synthetic risk transfers, continuation vehicles, tokenised MMF settlement, private-credit ratings arbitrage.
- The reviewer checks the core claim against the sources. A concept that passes is added with status `provisional`, and after its second appearance it becomes `established`. A concept that fails is dropped, and the story falls back to the closest existing concept.
- A **new-concept slot**: about once a week, the selection step favours a story whose mechanism isn't on the list yet, so the curriculum keeps tracking what is new in markets rather than only revisiting old ground.
- A monthly housekeeping task merges duplicate concepts and links related ones (e.g. `CR-NAV-FACILITY` ↔ `ALT-CONTINUATION-VEHICLE`), so spaced repetition can follow these links between concepts.
- New concepts are marked **NEW CONCEPT** on the page, so you know when you are learning something new rather than revising something familiar.

## 3. Data contract (summary)
`latest.json` is the same file as `editions/YYYY-MM-DD.json`. It contains:
- edition metadata
- `epub_url` and `sha256`
- `stories[]`, each with `concept_ids[]`, `news`, `plumbing`, `why_it_matters`, `interview_line`, and `questions[]`
- each question has a stem, options, `answer_index` (counting from 0), an explanation, and misconception tags for the wrong options

The full schema is in [03](03-koreader-architecture.md). The concept IDs (54 of them, such as `CR-PIK`, `FI-CONVEXITY`, `MS-BASIS-TRADE`) come from the taxonomy in [02](02-cfa-professor.md).

## 4. Repository layout (planned)
```
plumbing-dispatch/
├─ generator/            # Python: fetch feeds → select → write → review → build EPUB/JSON/OPDS
│  ├─ taxonomy.yaml      # concept IDs, tiers, core claims (ground truth for the reviewer)
│  ├─ prompts/           # select.md, write.md, review.md
│  └─ templates/         # broadsheet CSS + XHTML (from 05-sample-edition.html)
├─ plugin/plumbingdispatch.koplugin/   # _meta.lua, main.lua, quiz.lua, store.lua
├─ docs/                 # GitHub Pages output: latest.json, editions/, epub/, opds.xml
└─ .github/workflows/daily.yml
```

## 5. Sources and hosting
- **Facts come from free primary sources:** the Fed, NY Fed, ECB, BoE, OFR and SEC EDGAR (BDC 10-Qs and 8-Ks), plus free RSS feeds. Paywalled headlines are used only to *spot* topics. All content is summarised, never reproduced.
- **Hosting:** GitHub Pages on a free plan is public. The content is original commentary, so a public site is acceptable. If you want it private, use Cloudflare Pages with Access, or publish to a private repo's raw URL fetched with a read-only token.

## 6. Build order
1. **Week 1, content first.** Write the generator and run it locally for 5 days. You grade the output: is it the right depth, and are the answer keys correct? This is the step that matters most.
2. **Week 2, delivery.** Set up the scheduled Claude Code task, build the EPUB, publish to Pages, and add the OPDS feed. At this point it already works on the Kindle through KOReader's OPDS browser, with no plugin.
3. **Week 3, plugin.** Add one-tap fetch, the native quiz, local results and the review deck.
4. **Later.** v2 result sync, and remediation pieces triggered by repeated misconception tags.

## 7. Open items to check
- KOReader: the `ButtonDialog` `align` and `title_align` options, whether a plugin can catch an "end of book" event to offer the drill automatically, and how well MathML renders. All three are marked in [03](03-koreader-architecture.md).
- The sample HTML has not yet been tested on a real Kindle; the drop cap needs a fallback on older crengine builds.
- Check the cost estimate against current API prices once a model is chosen.
