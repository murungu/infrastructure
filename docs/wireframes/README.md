# ArityTheme Wireframe Library — Historical Reference

**ArityTheme is paused. Meridian is the active focus.**
This library preserves ArityTheme design comparisons and handoffs, not a current implementation queue.
Labels such as CURRENT and PROPOSED describe the original review, not today's storefront.

See the [current direction](../branding/README.md) and application [current plan](../../nopcommerce-src/.agent/plan.md).
A new Meridian task needs its own scope and acceptance criteria.
These wireframes do not replace Meridian's design or authorize theme edits, runtime changes, or deployment.

The template examples below remain reference material only.

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
| 21 | [responsive-footer.html](21-responsive-footer.html) | All pages | Generic store identity, inaccessible mobile disclosures, undersized controls, and mismatched desktop rails weaken the footer | 375/768/1280px |
| 22 | [category-listing.html](22-category-listing.html) | Category / PLP | Supporting blocks precede the title, category navigation is hidden on phones, controls are 32px, ratings show with no reviews, and the desktop rail is capped at 980px | 375/768/1280px |
| 23 | [category-panel-navigation.html](23-category-panel-navigation.html) | Category / PLP | The supporting category tree is mechanically sound but too tall, has no current-page state, and does not match the approved storefront taxonomy | 375/768/1280px |

Wireframes 18 through 23 have ArityTheme implementations. See the theme-owned homepage, footer, catalog, and category-navigation overrides.
This implementation history does not authorize further work on the paused theme.

## Implementation Plans

Historical wireframe handoffs remain beside their designs. They are not active tasks.

- Wireframe 22 → [22-category-listing-implementation-plan.md](22-category-listing-implementation-plan.md) — approved handoff plan; implementation shipped.

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
