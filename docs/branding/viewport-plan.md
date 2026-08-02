# Arity Theme — Viewport & Breakpoint Discipline Plan

> **Purpose:** One written set of rules for responsive theming. Follow these rules and the theme will not break when nopCommerce, browsers, or our team change things.
> **Scope:** CSS and views inside `Themes/ArityTheme/` only. No core edits. No new tooling.
> **Status:** Proposed — merge after review.

---

## 1. The Baseline Rule

**We never invent a breakpoint.** We mirror DefaultClean's exact breakpoint values. DefaultClean's 8,500-line stylesheet already divides the viewport space. Every media query we add must align with an existing DefaultClean seam. If it does not align, it fights the base theme on the 1-pixel boundaries.

| Seam | Base (mobile-first) | Override form (removals only) |
|---|---|---|
| Tiny phones → small tablets | `@media (min-width: 481px)` | `@media (max-width: 480px)` |
| Tablet portrait → desktop | `@media (min-width: 769px)` | `@media (max-width: 768px)` |
| Desktop → large desktop | `@media (min-width: 1001px)` | `@media (max-width: 1000px)` |
| Large → extra large | `@media (min-width: 1367px)` | `@media (max-width: 1366px)` |

The pairs tile without gaps or overlap. `max-width: 768px` and `min-width: 769px` never fight. Our current 768/769 mix has not broken anything. But this is only luck. If someone writes `min-width: 768px`, the theme will break. This document removes the luck.

## 2. New Code Is Mobile-First

Write new styles with no media query. That is the mobile rule. Then add `@media (min-width: …)` blocks to grow into desktop.

Use `max-width` form only when you remove or neutralize a DefaultClean desktop rule on smaller screens. In that case, mirror the exact `max-width` value DefaultClean uses for that component. The usual values are `max-width: 1000px` or `max-width: 769px`.

```css
/* NEW code — mobile-first */
.arity-product-card { display: block; }
@media (min-width: 769px) {
  .arity-product-card { display: grid; grid-template-columns: 1fr 2fr; }
}

/* OVERRIDE of DefaultClean — mirror its own seam */
@media all and (max-width: 1000px) {
  .cart tr { border: none; }
}
```

## 3. Viewport Test Matrix

Every theme change gets three screenshots before it is called done. No exceptions.

| Width | Device class | Why it matters |
|---|---|---|
| **375px** | Phone | Dominant viewport in the South African market. The header, product grid, and cart must survive here. |
| **768px** | Tablet portrait | Exactly on our mobile/desktop seam. Catches the `min-width: 769px` boundary. |
| **1280px** | Laptop | The developer/reference viewport. Most review screenshots live here. |

Add **1367px+** as a fourth check only for changes that touch full-width containers or the mega menu.

Screenshot loop (Playwright, already installed):

```js
for (const w of [375, 768, 1280]) {
  await page.setViewportSize({ width: w, height: 900 });
  await page.goto(url, { waitUntil: 'networkidle' });
  await page.screenshot({ path: `/tmp/check-${w}.png`, fullPage: false });
}
```

## 4. The Don't-Break-Rules

These are the invariants. If you break one, the theme silently degrades:

1. **Bundle order is fixed.** `Head.cshtml` registers files in this order: `styles.css` → `arity.tokens` → `arity.base` → `arity.nav` → `arity.icons` → `arity.products` → `arity.footer`. Never reorder. Later files win ties. That is the design.
2. **After any CSS change, clear bundles and restart.** Then judge the screenshot. Run this command: `docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/* && docker restart db-infra-nopcommerce`. Stale bundles are the #1 false result.
3. **One surface per deploy.** A surface = header, product grid, PDP, cart, or footer. Viewport bugs hide when you change two surfaces at once.
4. **`!important` has exactly one legal use.** Kill DefaultClean PNG background images on the exact selector that injects them. This makes room for the Lucide SVG replacement. See THEME-GUIDE lesson 2–3. Every other `!important` goes on the audit list (Section 6).
5. **Directional properties are logical.** New or touched lines must use `margin-inline-start`, `padding-inline-end`, `border-inline-start`, `text-align: start`, or `inset-inline-start`. Never add `left`/`right` physical properties in `arity.*.css`. Fix the lines you touch. Do not start a rewrite campaign.
6. **Tokens flow down.** Values come from `--arity-*` tokens. Hardcoded hex in module files is a bug. The only exception is a one-off override of a DefaultClean rule.

## 5. Token Source of Truth

`Design.md` (150 lines, full color ramp) and `arity.tokens.css` (18 lines, 8 colors) drifted apart. Decision:

- **`Design.md` is the source of truth** for the design system.
- Expand `arity.tokens.css` to expose the ramp as `--arity-*` custom properties. Do this in a controlled pass. Make it a single PR with CSS only. It must make zero visual change. New tokens must not be referenced until a later PR uses them.
- After that pass: module files reference tokens. No color appears twice under two names.

## 6. Remediation Backlog

Ordered, small, each item shippable alone. No big-bang refactors.

| # | Task | Effort | Risk |
|---|---|---|---|
| 1 | Logical-property sweep in `arity.nav.css` and `arity.products.css` | 1–2 h | Low. Mechanical work. Screenshot-verify at 3 widths. |
| 2 | `!important` registry. Table every one of the 74 declarations (file, selector, reason). Delete any that is not the icon-kill pattern. Target under 25. | 2 h | Medium. Each deletion needs screenshot verification. |
| 3 | Wrap media queries per concern, in-file. Keep `@media` blocks beside the rules they modify inside each module file. This is policy only. | Policy | None. |
| 4 | Token expansion pass (Section 5) | 1 h | Zero. Additive only. |
| 5 | RTL smoke check. Temporarily set `SupportRTL` path on a test store. Screenshot 375/768/1280 in `styles.rtl.css` mode. | 1 h | Low. Read-only check. |

## 7. What This Plan Does NOT Change

- The hot-copy deploy loop. It stays the 30-second feedback cycle.
- The modular file split. Six `arity.*.css` files stay as-is.
- The fallback/override doctrine. Views still override by copy. Core stays untouched.
- The blog post's tutorial path. It remains valid documentation for onboarding. It is Phase-0 knowledge. Our production wiring (bundling via `Head.cshtml`) supersedes its `asp-append-version` link-tag approach.

## 8. Open Questions for Owner

1. **Viewport list confirmed?** 375 / 768 / 1280 are mandatory. 1367 is conditional. Correct me if the analytics say otherwise.
2. **`Design.md` as token source — agree?** If the visual brand moved past `Design.md`, point me at the current source. I will flip the mapping.
3. **`!important` target of <25 — acceptable ambition?** Or do you want a hard 0 with selector-escalation instead? Hard 0 doubles the work of item 2.

---

*Written from the 2026-08-01 architecture review. Sources: blog-post comparison, CSS audit (breakpoints, media-query count, `!important` census, logical-property usage), and peer review of the theming approach.*
