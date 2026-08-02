# Wireframe-First Workflow

> Use wireframes before writing any CSS. Review them. Then implement.

## How to Use Wireframes

### Step 1: Identify the Problem

Find the issue in [mobile-first-audit.md](../branding/mobile-first-audit.md) or [ui-gaps.md](../branding/ui-gaps.md).

### Step 2: Create or Open the Wireframe

Each wireframe shows **CURRENT** (red banner) vs **PROPOSED** (green banner) at 375px.

Open any `.html` file in Chrome:

- DevTools → Toggle device toolbar (Cmd+Shift+M)
- Select "iPhone X" (375×812)
- Scroll to compare both versions

### Step 3: Review and Decide

Ask:

- Does the proposed layout solve the problem?
- Are touch targets ≥ 44×44px?
- Is content readable without zoom?
- Is the primary action visible above the fold?

If yes → proceed to Step 4.  
If no → edit the wireframe HTML, review again.

### Step 4: Implement in Theme

Edit the actual theme files:

```
nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/
```

Follow the hot-copy workflow from [theme-playbook.md](../branding/theme-playbook.md).

### Step 5: Verify with Screenshots

Screenshot at 375/768/1280px. Compare with the wireframe.

If the implementation matches the wireframe → commit.  
If not → iterate.

---

## Wireframe Library

| # | File | Page | Issue | Status |
|---|---|---|---|---|
| 01 | [category-page.html](01-category-page.html) | Category | Sidebar blocks products | Reviewed |
| 02 | [product-card-actions.html](02-product-card-actions.html) | Product Grid | Tiny touch targets | Reviewed |
| 03 | [pdp-variants.html](03-pdp-variants.html) | Product Detail | Dense variant selectors | Reviewed |
| 04 | [homepage-categories.html](04-homepage-categories.html) | Homepage | Oversized category images | Reviewed |
| 05 | [empty-cart.html](05-empty-cart.html) | Cart | Dead end, no CTA | Reviewed |
| 06 | [checkout-flow.html](06-checkout-flow.html) | Checkout | Long form, no progress | Draft |
| 07 | [mobile-menu.html](07-mobile-menu.html) | Navigation | Text-only menu | Draft |
| 08 | [search-results.html](08-search-results.html) | Search | No filters visible | Draft |

---

## How to Create a New Wireframe

Copy an existing wireframe and modify:

```bash
cp 01-category-page.html 09-your-new-page.html
```

Edit the HTML. Keep the structure:

- `div class="phone"` for each version
- `div class="badge current"` and `div class="badge proposed"`
- Inline CSS for simplicity

Add to this README. Commit.

---

## Why Wireframe-First?

1. **Faster than CSS.** Edit HTML in 5 minutes vs. 30 minutes of CSS tweaking.
2. **No build needed.** Open in browser, no `dotnet build`, no Docker restart.
3. **Reviewable by anyone.** Stakeholders can see the layout without understanding CSS.
4. **Prevents regressions.** Wireframe is the spec. Implementation must match.
5. **Reusable.** Template works for any page type.

---

*Part of the Arity Shop mobile-first design system.*
*See [viewport-plan.md](../branding/viewport-plan.md) for breakpoint rules.*
*Last updated: 2026-08-02*
