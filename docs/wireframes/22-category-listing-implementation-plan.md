# Wireframe 22 — Category listing implementation plan (agent handoff)

**Status:** approved wireframe, implementation not started
**Wireframe:** [`22-category-listing.html`](22-category-listing.html)
**Target repository:** `arity.nopCommerce.shop` (the nested `nopcommerce-src/` checkout)
**Suggested branch:** `feat/category-listing`

This document is the complete brief for the agent that implements Wireframe 22.
Read the wireframe file in a browser first — it holds the measurements, the
current/proposed comparison at 375/768/1280px, and the approved decision list.

---

## 1. Non-negotiable rules

1. **Do not modify nopCommerce core.** Every change lives inside
   `src/Presentation/Nop.Web/Themes/ArityTheme`.
2. **Do not hardcode catalog data.** No category names, product names, prices,
   counts, brand names, or IDs in markup or CSS. Everything comes from the model.
3. **Do not change behavior that already works.** AJAX product loading, sorting,
   per-page, view mode, paging, filters, subcategories, featured products, and
   every widget zone must keep working exactly as they do now.
4. **Brand:** Inter for all text, black/white surfaces with hairline greys,
   sentence case, square corners, no shadows, no gradients, no decorative
   colour, 44px minimum interactive targets.
5. **Rail:** 16px mobile gutters, 24px tablet gutters, 32px desktop gutters,
   1600px max width. Same rail as the hero, homepage categories, homepage
   products, and footer.

---

## 2. What is wrong today (verified on `http://localhost:5000/desktops`)

| Item                 | 375px                           | 768px                           | 1280px           |
| -------------------- | ------------------------------- | ------------------------------- | ---------------- |
| Content rail         | 338px (19px gutters)            | 710px (29px gutters)            | 980px wrapper    |
| Main column          | 338px                           | 710px                           | 715px            |
| Sidebar              | full width, **above the title** | full width, **above the title** | 245px            |
| Category navigation  | `display: none`                 | `display: none`                 | visible          |
| Columns / card width | 1 / 338px                       | 2 / 348px                       | 3 / 231px        |
| Product image        | 304px                           | 314px                           | **197px**        |
| Sort select          | 155 × 32                        | 155 × 32                        | 155 × 32         |
| Per-page select      | 50 × 32                         | 50 × 32                         | 50 × 32          |
| Card actions         | 204 × 40, 40, 40                | 214 × 40, 40, 40                | 101 × 40, 38, 38 |

Root causes worth knowing before you start:

- `Views/Shared/_ColumnsTwo.cshtml` renders `<aside class="side-2">` **before**
  `<section class="center-2">`, so on narrow screens the manufacturer and tag
  blocks stack above the page title.
- `Themes/ArityTheme/Content/css/styles.css` contains
  `.block-category-navigation { display: none; }` inside
  `@media all and (max-width: 1000px)`.
- `Themes/ArityTheme/Content/css/arity.products.css` line ~42 applies
  `text-transform: uppercase` to `.product-box-add-to-cart-button`.
- The theme `Views/Shared/_ProductBox.cshtml` renders the compare button and an
  unconditional five-star `product-rating-box` whenever
  `AllowCustomerReviews` is true, including when `TotalReviews == 0`.

---

## 3. Approved target

Order on every viewport: **breadcrumb → title → product count → toolbar →
product grid → pager → supporting blocks.**

|                   | 375px                     | 768px                       | 1280px                            |
| ----------------- | ------------------------- | --------------------------- | --------------------------------- |
| Rail              | 343px (16px gutters)      | 720px (24px gutters)        | 1216px (32px gutters, 1600px cap) |
| Layout            | single column             | single column               | 260px sidebar + 32px gap + main   |
| Columns           | 2                         | 3                           | 3                                 |
| Card width        | ~163px                    | ~229px                      | ~297px                            |
| Product image     | square, fills card        | square                      | ~273px                            |
| Sort              | full-width 44px control   | 44px control, right aligned | 44px control, right aligned       |
| Per-page          | hidden                    | hidden                      | 44px control                      |
| View mode         | hidden                    | hidden                      | two 44px buttons                  |
| Supporting blocks | accordions below the grid | accordions below the grid   | sidebar                           |

Card contents, in order: image, name, SKU (only when
`catalogSettings.ShowSkuOnCatalogPages`), rating (**only when
`ReviewOverviewModel.TotalReviews > 0`**), price, actions.

Card actions:

- Mobile two-up grid: full-width “Add to cart” (44px) with the 44px wishlist
  button positioned on the image corner, so the label never wraps.
- Tablet and desktop: “Add to cart” and the 44px wishlist button in one row.
- **No compare button anywhere on the listing card.**

Counts:

- Under the title on every viewport: “N products” from
  `CatalogProductsModel.TotalItems`.
- Beside the desktop sort controls: “Showing 1–6 of 12”, derived from
  `PageIndex`, `PageSize`, and `TotalItems` on the existing pageable model.

---

## 4. Files to touch

All paths are relative to
`nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/`.

| File                                                          | Action              | Purpose                                                          |
| ------------------------------------------------------------- | ------------------- | ---------------------------------------------------------------- |
| `Views/Catalog/CategoryTemplate.ProductsInGridOrLines.cshtml` | new theme override  | Title + count composition, register the catalog stylesheet       |
| `Views/Catalog/_CatalogSelectors.cshtml`                      | new theme override  | 44px controls, desktop-only per-page and view mode, result range |
| `Views/Catalog/_ProductsInGridOrLines.cshtml`                 | new theme override  | Grid wrapper and pager markup hooks                              |
| `Views/Shared/_ProductBox.cshtml`                             | edit existing       | Remove compare, gate the rating on `TotalReviews > 0`            |
| `Content/css/arity.catalog.css`                               | new                 | All listing layout, grid, toolbar, sidebar, and accordion styles |
| `Content/js/arity.catalog.js`                                 | new, only if needed | Accordion disclosure for the mobile supporting blocks            |
| `Content/css/arity.products.css`                              | edit existing       | Remove the uppercase transform on the catalog add-to-cart button |

Copy each core view from `src/Presentation/Nop.Web/Views/Catalog/` before
editing it, so the theme override starts from the current core markup and keeps
every widget zone, script block, and model branch.

### Verified facts about the theme mechanics

- Theme view resolution already works for `Views/Product/` and `Views/Shared/`
  in this theme, so `Views/Catalog/` resolves the same way. No registration is
  needed.
- `Themes/ArityTheme/Views/_ViewImports.cshtml` applies to subfolders, so the
  new views need no extra `@using` plumbing beyond what the core views declare.
- Page-level `NopHtml.AppendCssFileParts(...)` calls land **last** in the
  generated bundle. This was confirmed by reading the live homepage bundle:
  `arity.home-products.css` appears at byte 210174 of 215832. A catalog
  stylesheet registered from the category view therefore overrides
  `styles.css`, `arity.base.css`, and `arity.products.css` by order. Keep
  selectors specific anyway, because `styles.css` uses some wide rules.
- Register the stylesheet from the category view, not from
  `Views/Shared/Head.cshtml`, so homepage and other pages do not download it.
  Follow the pattern in `Views/Home/Index.cshtml`.

---

## 5. Implementation order

Work in small, verifiable steps. Build and check the live page after each one.

1. **Branch.** From nested `main`, create `feat/category-listing`. Leave the
   pre-existing unrelated `src/.idea/.idea.NopCommerce/.idea/workspace.xml`
   modification unstaged; never commit it.
2. **Card cleanup.** In `Views/Shared/_ProductBox.cshtml`, remove the compare
   button block and wrap the `product-rating-box` in
   `@if (Model.ReviewOverviewModel.AllowCustomerReviews && Model.ReviewOverviewModel.TotalReviews > 0)`.
   Remove the uppercase transform from `arity.products.css`. Verify the
   homepage and search pages still render correctly, because they share this
   partial.
3. **Stylesheet skeleton.** Add `Content/css/arity.catalog.css` and register it
   from the new theme `CategoryTemplate.ProductsInGridOrLines.cshtml`. Apply the
   rail and the responsive grid first. Confirm the grid resolves to 2 / 3 / 3
   columns.
4. **Source order.** Fix the title-before-blocks problem with CSS ordering on
   the catalog page only. Scope it to `.html-category-page` — the category view
   already calls `NopHtml.AppendPageCssClassParts("html-category-page")`, so the
   class is on `<body>`. Do **not** copy `_ColumnsTwo.cshtml` into the theme
   unless CSS ordering genuinely cannot work; other two-column pages must keep
   their current behavior. If a layout copy becomes unavoidable, it still lives
   in the theme, and you must re-check the account, vendor, and manufacturer
   pages that use the same layout.
5. **Toolbar.** Override `_CatalogSelectors.cshtml`: 44px controls, desktop-only
   per-page and view mode, and the result range. Keep every existing
   `CatalogProducts` script handler exactly as the core view declares them.
6. **Supporting blocks.** Show category navigation below 1001px as accessible
   accordions. Use real `<button>` elements with `aria-expanded` and
   `aria-controls`, and keep closed content out of the tab order. Reuse the
   footer accordion approach in `Content/js/arity.footer.js` if it fits;
   otherwise add a small catalog-specific script and register it the same way.
7. **Pager.** Give pager links a 44px target. Do not change the pager helper
   call or the `addPagerHandlers` wiring.
8. **Sweep.** Check manufacturer pages, search results, tag pages, and vendor
   pages — they share `_CatalogSelectors.cshtml` and
   `_ProductsInGridOrLines.cshtml`. Either the changes suit them too, or your
   selectors must be scoped so those pages are untouched. State which you chose.

---

## 6. Verification gate

Do not open the pull request until all of these pass.

### Build

```bash
cd nopcommerce-src/src/Presentation/Nop.Web
dotnet build
```

Expect 0 errors and 0 warnings.

### Live browser checks

On `http://localhost:5000/desktops` at 375, 768, 1280, and 1920px:

- No horizontal overflow: `document.documentElement.scrollWidth <= window.innerWidth`.
- No console errors.
- Zero interactive controls under 44px in either dimension: sort, per-page, view
  mode, pager links, “Add to cart”, wishlist, accordion buttons.
- Grid resolves to 2 columns at 375, 3 at 768, 3 at 1280 beside the sidebar.
- The `<h1>` appears above the manufacturer and tag blocks at every width.
- Category navigation is reachable at 375 and 768.
- Product count matches the number of products the category actually holds.
- No empty five-star row on a product with zero reviews.
- No compare button on any listing card.
- Keyboard: tab order follows visual order, focus is always visible, and closed
  accordion content is not focusable.

### Behavior checks

- Changing sort reloads products through AJAX and keeps the URL behavior it has
  today.
- Changing per-page on desktop reloads products.
- Switching grid and list view still works on desktop.
- Paging works, and the pager handlers rebind after an AJAX load.
- A category with filters enabled still renders the filter partials.
- A category with subcategories and featured products still renders both.

### Regression checks

- Homepage renders unchanged.
- Search results page renders sensibly with the shared partials.
- A manufacturer page renders sensibly.

---

## 7. Delivery

1. Commit only the intended ArityTheme paths. Never stage
   `src/.idea/.idea.NopCommerce/.idea/workspace.xml`.
2. Commit message style: `feat(theme): redesign category product listing`.
3. Push to `Arity-Solutions/arity.nopCommerce.shop` and open a pull request
   against `main`. Link this plan and the wireframe in the description.
4. In the pull request body, record: measured card and image widths at each
   viewport, the build result, the browser check results, which shared pages you
   swept in step 8, and any decision you made that this plan did not cover.

---

## 8. Known open items, not in scope

- Sample catalog data (Computers, Desktops, IBM, Lenovo) is corrected in
  nopCommerce administration, not in the theme.
- Filter facets for renewable-energy specifications depend on specification
  attributes existing in admin. Implement the filter presentation the model
  already supports; do not invent filter groups.
- List view mode styling is not redesigned here. Keep it working and visually
  consistent, but the approved wireframe covers the grid mode.
