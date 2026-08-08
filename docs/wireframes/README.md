# Wireframe-First Workflow

> Use wireframes before writing any CSS. Review them at every viewport. Then implement.

## How to Use Wireframes

### Step 1: Identify the Problem

Find the issue in [mobile-first-audit.md](../branding/mobile-first-audit.md) or [ui-gaps.md](../branding/ui-gaps.md).

### Step 2: Create or Open the Wireframe

Every wireframe shows **CURRENT** (red) vs **PROPOSED** (green) at **three viewports**:

| Viewport | Size | What it represents |
|---|---|---|
| Mobile | 375px | Zimbabwe primary market — 55%+ of traffic |
| Tablet | 768px | iPad, Android tablets |
| Desktop | 1280px | Laptops and larger screens |

Open any `.html` file in Chrome. Use the viewport tabs at the top:

- Click **Mobile** to see 375px
- Click **Tablet** to see 768px
- Click **Desktop** to see 1280px

### Step 3: Review and Decide

Ask at **each viewport**:

- Does the layout work for this screen size?
- Are touch targets ≥ 44×44px on mobile?
- Is content readable without zoom?
- Is the primary action visible without scrolling?
- Does the layout scale gracefully?

If yes → proceed to Step 4.  
If no → edit the wireframe HTML, review again.

### Step 4: Implement in Theme

Edit the actual theme files:

```
nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/
```

Follow the hot-copy workflow from [theme-playbook.md](../branding/theme-playbook.md).

### Step 5: Verify with Screenshots

Screenshot at 375/768/1280px. Compare with the wireframe at each viewport.

If the implementation matches the wireframe at all three sizes → commit.  
If not → iterate.

---

## Wireframe Library

| # | File | Page | Issue | Viewports |
|---|---|---|---|---|
| 00 | [template.html](00-template.html) | Template | Starting point for a current/proposed review | 375/768/1280px |
| 01 | [category-page.html](01-category-page.html) | Category | Sidebar blocks products | 375px |
| 02 | [product-card-actions.html](02-product-card-actions.html) | Product Grid | Tiny touch targets | 375px |
| 03 | [pdp-variants.html](03-pdp-variants.html) | Product Detail | Dense variant selectors | 375px |
| 04 | [homepage-categories.html](04-homepage-categories.html) | Homepage | Oversized category images | 375px |
| 05 | [empty-cart.html](05-empty-cart.html) | Cart | Dead end, no CTA | 375px |
| 06 | [login-register.html](06-login-register.html) | Login/Register | Placeholder text, generic social | 375px |
| 07 | [cart-with-items.html](07-cart-with-items.html) | Cart | Small quantity buttons | 375px |
| 08 | [footer.html](08-footer.html) | All pages | Wrong store name, no WhatsApp | 375px |
| 09 | [product-detail-full.html](09-product-detail-full.html) | Product Detail | Generic layout, no specs | 375px |
| 10 | [wishlist.html](10-wishlist.html) | Wishlist | Small buttons, no stock info | 375px |
| 11 | [login-form-modern.html](11-login-form-modern.html) | Login | Legacy form compared with modern form styling | Responsive |
| 12 | [form-modern-target.html](12-form-modern-target.html) | Forms | Target label and field layout | 375/768/1280px |
| 13 | [side-by-side-comparison.html](13-side-by-side-comparison.html) | Login | Wireframe compared with implementation | 375/1280px |
| 14 | [register-desktop-comparison.html](14-register-desktop-comparison.html) | Register | Desktop wireframe compared with implementation | 1280px |
| 15 | [header-layout.html](15-header-layout.html) | Header | Single-row markup overflows on mobile | 375/768/1280px |
| 16 | [search-autocomplete.html](16-search-autocomplete.html) | Header search | Fixed-width autocomplete does not match responsive search | 375/768/1280px |
| 17 | [menu-navigation.html](17-menu-navigation.html) | Main menu | Ambiguous mobile disclosure and undersized desktop dropdown | 375/768/1280px |
| 18 | [homepage-banner-slider.html](18-homepage-banner-slider.html) | Homepage hero | Image-only promotion is unreadable on mobile and lacks safe carousel controls | 375/768/1280px |
| 19 | [homepage-introduction-categories.html](19-homepage-introduction-categories.html) | Homepage categories | Generic welcome copy and sample categories create an off-brand, inefficient catalog entry | 375/768/1280px |
| 20 | [homepage-featured-products.html](20-homepage-featured-products.html) | Homepage featured products | Cramped mobile cards, undersized actions, empty ratings, and a narrow legacy desktop rail weaken product discovery | 375/768/1280px |

Wireframes 18 and 19 are implemented in ArityTheme. See `Views/Home/Index.cshtml`, `Views/Home/_ArityHomepageHero.cshtml`, `Views/Shared/Components/HomepageCategories/Default.cshtml`, and their homepage-only CSS/JS modules.

---

## How to Create a New Wireframe

### Option A: Use the Multi-Viewport Template

Copy `00-template.html` and fill in the CURRENT and PROPOSED sections for each viewport:

```bash
cd docs/wireframes
cp 00-template.html 06-your-page.html
```

The template shows all three viewports (375/768/1280) in one file with tab navigation.

### Option B: Copy an Existing Wireframe

```bash
cp 01-category-page.html 06-your-page.html
```

Edit the HTML. Keep the structure:

- `div class="phone"` for each version
- `div class="badge current"` and `div class="badge proposed"`
- Inline CSS for simplicity

Add to this README. Commit.

---

## Multi-Viewport Template

The `00-template.html` file includes:

- Tab navigation: Mobile (375px) / Tablet (768px) / Desktop (1280px)
- Phone frame styling for each size
- "Current" and "Proposed" badges
- Arity Shop header and nav
- Content area for your layout
- Instructions in HTML comments

Use it for any new page.

---

## Why Wireframe-First?

1. **Faster than CSS.** Edit HTML in 5 minutes vs. 30 minutes of CSS tweaking.
2. **No build needed.** Open in browser. No `dotnet build`. No Docker restart.
3. **Reviewable by anyone.** Stakeholders can see the layout without understanding CSS.
4. **Prevents regressions.** Wireframe is the spec. Implementation must match.
5. **Multi-viewport by default.** You design for 375, 768, and 1280 simultaneously.
6. **Mobile-first enforcement.** You see mobile first, not as an afterthought.

---

*Part of the Arity Shop mobile-first design system.*
*See [viewport-plan.md](../branding/viewport-plan.md) for breakpoint rules.*
*Last updated: 2026-08-08*
