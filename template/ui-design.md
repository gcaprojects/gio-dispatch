# The Plumbing Dispatch: UI and typography (v0)

*Target: KOReader (crengine) on a 6–7" Kindle, 1072×1448 or 1264×1680 at 300 ppi, 16-level greyscale e-ink. Sample: `05-sample-edition.html`.*

## 1. Principles
- **One column, no ornament.** A 6" screen is about 90 mm wide. That is one broadsheet column, not six. The newspaper feel comes from the nameplate, rules, small caps and the order of the text, not from a multi-column layout.
- **Black on paper.** Body text is pure black (#000). Greys show only on hairline rules and the folio line. Mid-grey text on e-ink looks blurred.
- **Few page turns, no motion.** Every interaction is a page turn or a link jump. Nothing animates and nothing toggles.
- **The reader controls the font size.** All sizes are in `em`, so KOReader's font-size setting scales the whole page. No `px` sizes for text.

## 2. Page sequence
Each block starts on a new screen (`page-break-before: always`, which crengine honours).

1. **Front page.** Nameplate with the title in large roman caps between a double rule above and a thin rule below. Folio line in small caps: *Vol. I · No. 212 · Saturday, 17 October 2026 · Offline edition*. Then a one-line motto in italic. Below it, **"In this edition"**: a 3-row table (number, kicker, headline, page link). Close with a one-sentence "Interview line of the day".
2. **Story** (one per story). Kicker in letter-spaced caps (e.g. PRIVATE CREDIT), headline (bold, about 1.6 em), italic deck of one or two lines, then a dateline in small caps ("LONDON, 17 Oct.") that runs into the first paragraph, which opens with a three-line drop cap. Sections follow in fixed order, each under a small centred caps subhead between hairlines: **The News**, **The Plumbing**, **Why It Matters**, **Interview Line**.
3. **The Plumbing** is the dense part. It sets formulas as display lines and gives the worked example in a ruled table ("figures box") marked *Illustrative figures* in its caption.
4. **Drill.** A short page headed "The Drill" with numbered questions. Options are A–D in a hanging-indent list. Each question ends with a link: *Answer → p. A1*.
5. **Answers.** A separate page at the end of the story, set like a newspaper puzzle-page solution. The answer comes first ("**1. B.**"), then why it is right, then one line on why each wrong option is tempting, then "← back to question 1".

## 3. Type scale
Base = the reader's chosen size (1 em, typically 9–11 pt on device). Ratio is about 1.25, rounded:

| Role | Size | Style |
|---|---|---|
| Nameplate | 2.4 em | Roman caps, letter-spacing 0.04 em, bold weight optional |
| Headline | 1.6 em | Bold, line-height 1.15 |
| Deck | 1.1 em | Italic |
| Section subhead | 0.8 em | Caps, letter-spacing 0.15 em, centred |
| Kicker / folio / dateline | 0.75–0.8 em | Caps or small caps, letter-spaced |
| Body | 1 em | Justified, hyphenated, line-height 1.4 |
| Figures box / captions | 0.85 em | Tabular figures if the font has them |

Body text is justified, which is the newspaper convention. That works only with hyphenation on (`hyphens: auto` plus `lang="en-GB"`; KOReader's hyphenation dictionaries handle it). Paragraphs use a 1.2 em first-line indent with no space between, except the first paragraph after a heading, which is not indented.

## 4. Fonts
- **First choice: EB Garamond** or **Libre Caslon Text** (both SIL OFL, free). Caslon has the most "old newspaper" feel. Garamond has better small caps and old-style figures and stays robust at small sizes on e-ink.
- **Ships with KOReader:** *Noto Serif* (always there) is the safe fallback. Bookerly/Caecilia may be present on the Kindle but are not ours to depend on.
- **Stack:** `"Libre Caslon Text", "EB Garamond", "Noto Serif", Georgia, "Times New Roman", serif`. Georgia covers the desktop preview.
- **Embedding:** for the EPUB, embed the TTF/OTF through `@font-face` with a *local relative* `src` inside the EPUB. Never use a remote URL: the device is offline and crengine does not fetch them. The plain HTML preview does not embed fonts and relies on the stack.
- Set KOReader's font weight ("Font weight" +½ or +1) slightly bolder. Thin Garamond hairlines wash out on Carta panels. Suggest this once in the plugin's help text; do not force it in CSS.

## 5. Rules, small caps, drop caps
- **Rules:** a double rule (`3px double`) only under the nameplate and at the end of the edition. 1px solid black hairlines go between sections and around the figures box. A short centred 30% rule closes a story. There are no vertical column rules in single-column layout, so the figures-box table carries the "ruled" texture instead.
- **Small caps:** crengine supports `font-variant: small-caps` only when the font has an `smcp` OpenType feature (EB Garamond does). For robustness the sample uses *faux small caps*: `text-transform: uppercase; font-size: 0.8em; letter-spacing: 0.08em`. It looks right with every font.
- **Drop cap:** a `<span class="dropcap">` with `float: left`, about 3.2 em, line-height 0.85. Recent crengine supports floats. If it renders badly on an old build, the fallback is a bold, enlarged first word with no float, which degrades gracefully.

## 6. Formulas on e-ink
| Option | Verdict |
|---|---|
| **Plain text + Unicode** (×, ÷, ≥, Σ, `<sub>`/`<sup>`, a centred display line) | **Default.** Reflows, scales with font size, sharp, searchable, works in night mode. |
| MathML | crengine has partial MathML support since 2022; output varies by build. Use only for fractions that genuinely need stacking, and always pair it with a plain-text line. |
| Images (SVG/PNG) | Avoid. They do not scale with font size, look grey in night mode, and are blurry if rasterised. Last resort for large matrices only. |

House style for display formulas: one per line, centred, italic variables, upright numbers and operators. Spell out fractions as `(A − L) ÷ D`. Follow every formula immediately with its worked numbers on the next line.

## 7. Quiz flow (1–2 taps per question)
**In the EPUB/HTML (the default):** the question page lists options A–D. The reader answers in their head and taps **one** link, "Answer 1 →", which jumps to `#ans-1` on the Answers page. A second tap, "← back", returns them (KOReader's own "go back" gesture also works). That is 2 taps per question. Answers are never on the same screen as the question, so nothing has to be hidden and nothing flashes. The reader turns past the Answers page to reach the next story.

**In the native plugin (optional):** a KOReader `ButtonDialog` with four buttons (A–D). Tap 1 picks an option. The dialog closes and a `TextViewer` opens with the verdict as the first line ("Correct: B" / "You chose C; answer is B") followed by the explanation. Tap 2 closes it. Record the score then. Use full-screen dialogs only. Avoid toasts/`InfoMessage` with timeouts, because they cause extra partial refreshes.

## 8. Night mode
- KOReader's night mode inverts the whole framebuffer. Design for black on white and let inversion do the work. **Do not** ship a separate dark stylesheet.
- The off-white page tint (#f7f4ec) is for the desktop preview. On device, crengine usually ignores body background unless "embedded styles" are fully on, and inverted it becomes a muddy dark grey. The generator should drop `background` from the EPUB CSS.
- No grey text below about #555, because inverted it becomes faint. Hairlines must be at least 1px solid black.

## 9. What not to do on e-ink
- No flexbox, grid, `position: fixed/absolute`, `vh`/`vw`, multi-column CSS, JavaScript, `:hover`, transitions, or web fonts from URLs.
- No shaded boxes, background fills or grey tints behind text. They dither into noise.
- No pictograms or emoji. Use the arrows (→ ←) and § only.
- No light weights, no text under 0.75 em, no long italic passages (italic is for decks and captions).
- No reveal-on-tap or spoiler blocks: CSS toggles need `:target`/`details`, which crengine does not support reliably.
- No more than one table per screen. Tables wider than the screen break pagination, so keep them to 3 columns.
- No full-page images and no edge-to-edge black areas. They cause ghosting and trigger full refreshes.
