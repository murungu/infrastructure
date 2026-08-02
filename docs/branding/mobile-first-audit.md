# ArityTheme — Mobile-First Audit

> **Date:** 2026-08-02
> **Scope:** 5 pages × 3 viewports (375px / 768px / 1280px)
> **Tool:** Playwright Chromium + manual visual review
> **Goal:** Confirm DefaultClean mobile base is intact. Flag UX friction points before we customize.

---

## Verdict

**DefaultClean's mobile responsive behavior is intact.** Single-column layout, readable text, working navigation, usable forms. Nothing is broken.

**But:** The mobile experience is "functional, not delightful." Several UX friction points hurt the shopping flow on small screens. None are showstoppers, but they accumulate.

**Launch readiness for mobile:** ~75%. The 25% gap is mobile-specific UX polish — not structural.

---

## 🔴 P1 — Issues That Hurt Mobile Shopping

| # | Issue | Page | Evidence | Fix | Effort |
|---|---|---|---|---|---|
| 1 | **Sidebar blocks products on mobile** | Category | Manufacturers + Popular tags render **above** category images. Products pushed far down the page. | Move sidebar below product grid on mobile (`max-width: 768px`). Or hide Manufacturers/Tags blocks entirely on mobile. | 1 h |
| 2 | **Product card action buttons too small** | Homepage, Category | ADD TO CART is fine (full-width), but compare ❤️ and wishlist 💙 buttons are ≈32×32px. 72+ elements fail 44×44px WCAG touch target. | Increase icon-button padding to `min(44px, 100%)`. Or make action buttons stack vertically below ADD TO CART on mobile. | 1 h |
| 3 | **Variant selectors are dense** | PDP | Processor/RAM/HDD/OS radios and dropdowns are small, tightly packed. Hard to tap accurately on 375px. | Increase `padding-block` and `margin-block` on `.attribute-list li`. Make dropdowns full-width. Add `min-height: 44px` to all form inputs. | 1 h |
| 4 | **Product description = wall of text** | PDP | Single massive paragraph, poor line-height (≈1.2). Hard to scan on mobile. | Add `line-height: 1.6` to `.full-description`. Split into shorter paragraphs if content allows. | 30 min |
| 5 | **Category images oversized on homepage** | Homepage | Each category image is ≈200px tall. Only 1 category visible above fold. Users must scroll to see "Featured products". | Reduce category image height to `120px` on mobile. Or collapse category blocks into a horizontal scroll. | 30 min |
| 6 | **Breadcrumb wraps awkwardly** | PDP | "Home / Computers / Desktops / Build your own computer" is long and wraps on narrow screens. | Truncate with ellipsis on mobile, or hide middle segments (show `Home / ... / Product Name`). | 30 min |

---

## 🟡 P2 — Polish Items

| # | Issue | Page | Evidence | Fix | Effort |
|---|---|---|---|---|---|
| 7 | **Search button below field** | All | Search input + button stack vertically, using 2 rows. | Make search input + button inline on mobile via flexbox. | 30 min |
| 8 | **"About login / registration" placeholder** | Login | Default nopCommerce placeholder text visible below login form. | Edit admin → Content Management → Topics → `LoginPageText`. | 15 min |
| 9 | **"Powered by nopCommerce"** | All | Visible in footer on every page. | Remove in `_Footer.cshtml` or via CSS. | 15 min |
| 10 | **Copyright says "Arty Store"** | All | Should be "Arity Shop". | Fix in admin or footer view. | 5 min |

---

## ✅ What's Working Well on Mobile

| Feature | Status | Notes |
|---|---|---|
| Header collapse | ✅ | Icons + CATEGORIES button works correctly |
| Product grid | ✅ | Single-column, full-width cards |
| Footer accordions | ✅ | Information, Customer service, My account all collapse/expand |
| Login form | ✅ | Readable, usable, good spacing |
| Cart page | ✅ | Clean, simple, no clutter |
| Image scaling | ✅ | No distortion, proper aspect ratios |
| Horizontal scrolling | ✅ | None detected (1px overflow is scrollbar artifact) |
| Touch targets (primary) | ✅ | ADD TO CART buttons are full-width and large |
| Viewport meta | ✅ | `width=device-width, initial-scale=1` present |

---

## Screenshots

Captured during this audit:

```
docs/screenshots/2026-08-02/
├── mobile-test-homepage-mobile.png     # 375px
├── mobile-test-homepage-tablet.png     # 768px
├── mobile-test-homepage-desktop.png    # 1280px
├── mobile-test-category-mobile.png     # 375px
├── mobile-test-category-tablet.png     # 768px
├── mobile-test-category-desktop.png    # 1280px
├── mobile-test-product-detail-mobile.png
├── mobile-test-product-detail-tablet.png
├── mobile-test-product-detail-desktop.png
├── mobile-test-cart-mobile.png
├── mobile-test-cart-tablet.png
├── mobile-test-cart-desktop.png
├── mobile-test-login-mobile.png
├── mobile-test-login-tablet.png
└── mobile-test-login-desktop.png
```

**Store these with the 2026-08-01 screenshots.**

---

## Recommended Fix Order

**Before any content work** (product images, descriptions), fix these mobile issues first. Mobile is the dominant viewport for our target market.

**Week 1 — Quick wins (2 hours total):**

1. Fix copyright (5 min)
2. Remove "Powered by nopCommerce" (15 min)
3. Fix login placeholder text (15 min)
4. Increase product description line-height (30 min)
5. Reduce homepage category image height on mobile (30 min)
6. Truncate breadcrumb on mobile (30 min)

**Week 2 — Structural (3 hours total):**
7. Move sidebar below products on mobile category page (1 h)
8. Increase touch targets on product cards (1 h)
9. Make variant selectors more tappable on PDP (1 h)

---

## How to Test Mobile Changes

After every CSS change, verify at 3 widths:

```bash
# Screenshot script (already installed)
node /path/to/screenshot-script.mjs http://localhost:8080/
```

Or manually in Chrome DevTools:

1. Open DevTools → Toggle device toolbar
2. Select **iPhone X** (375×812) or **Responsive** at 375px width
3. Check: no horizontal scroll, buttons are tappable, text is readable

**Screenshot before/after each change.** Store in `docs/screenshots/YYYY-MM-DD/`.

---

## Related Documents

- [viewport-plan.md](viewport-plan.md) — Breakpoint rules (mobile-first `min-width`, `max-width` only for overrides)
- [ui-gaps.md](ui-gaps.md) — General UI review (desktop + content + branding gaps)
- [theme-playbook.md](theme-playbook.md) — How to make theme changes safely

---

*Audit conducted with Playwright at 375px / 768px / 1280px. All screenshots saved to `/tmp/mobile-test-*` and should be copied to `docs/screenshots/2026-08-02/`.*
