# Arity Theme Customization Playbook

> How to modify the Arity nopCommerce theme with confidence and speed.
> **Scope:** You want to customize themes. You do not want to rebuild nopCommerce from scratch.

---

## 1. The Mental Model (Read This Once)

nopCommerce themes work on **override + fallback**:

```
Themes/ArityTheme/Views/     ← YOUR THEME (you edit here)
Views/                        ← CORE nopCommerce (NEVER edit)
```

When nopCommerce needs a view (for example, `Shared/_Header.cshtml`):

1. It looks in `Themes/ArityTheme/Views/Shared/_Header.cshtml`.
2. If it finds the file, it uses the theme version.
3. If it does not find the file, it falls back to `Views/Shared/_Header.cshtml`.

**The Rule:**

- **Copy to override.** Find the core view. Copy it into the theme at the same path. Then edit it.
- **Delete to revert.** Remove your copy. The core fallback kicks in automatically.
- **Never edit `Views/`.** Those are core files. You will lose the edits on updates.

### How a Page Renders

```
Browser request
  → Controller (for example, HomeController.Index)
    → Returns a View (for example, Views/Home/Index.cshtml)
      → View uses a Layout (_Root.cshtml)
        → _Root.cshtml loads Head.cshtml
          → Head.cshtml registers CSS files
            → CSS is bundled and minified → browser
```

**Key insight:** Your theme controls the HTML through copied views. It controls the CSS through `Content/css/`. The C# backend stays untouched.

---

## 2. Your Theme File Map

```
src/Presentation/Nop.Web/Themes/ArityTheme/
├── theme.json                          ← Theme metadata (name, RTL support)
├── preview.jpg                         ← Admin thumbnail
├── Design.md                           ← Arity design system spec (colors, typography, shapes)
├── Content/
│   ├── css/
│   │   ├── styles.css                  ← Main stylesheet (DefaultClean base + Arity overrides)
│   │   ├── styles.rtl.css              ← RTL mirror (must stay in sync with styles.css)
│   │   ├── print.css                   ← Print stylesheet
│   │   ├── arity.tokens.css            ← BRAND DNA: colors, fonts, spacing variables
│   │   ├── arity.base.css              ← Global body, typography, link overrides
│   │   ├── arity.nav.css               ← Header, search, mega menu
│   │   ├── arity.products.css          ← Product cards, category grids, PDP
│   │   ├── arity.footer.css            ← Black Arity footer
│   │   └── arity.icons.css             ← Lucide SVG icon overrides
│   └── images/
│       ├── logo.png                    ← Arity Shop logo
│       └── ...                         ← Icons, favicons, sprites
├── Views/
│   ├── _ViewImports.cshtml             ← @using directives for Razor
│   ├── _Root.cshtml                    ← Master layout (wrapper divs, widget zones)
│   ├── Shared/
│   │   ├── Head.cshtml                 ← CSS injection point (registers all CSS files)
│   │   ├── _Root.Head.cshtml           ← Page <head> skeleton (meta, title, scripts)
│   │   ├── _Header.cshtml              ← Site header (logo, search, cart, nav)
│   │   ├── _ProductBox.cshtml          ← Product card (grid listing)
│   │   ├── _ArityIcon.cshtml           ← Lucide SVG icon helper
│   │   └── Components/
│   │       ├── HeaderLinks/Default.cshtml
│   │       └── SearchBox/Default.cshtml
│   ├── Product/
│   │   ├── _AddToWishlist.cshtml
│   │   ├── _DeliveryInfo.cshtml
│   │   ├── _CompareProductsButton.cshtml
│   │   └── _ProductEmailAFriendButton.cshtml
│   └── ShoppingCart/
│       └── Wishlist.cshtml
```

**What exists already:** Phases 0–2 are complete. The theme exists. The brand identity is set. The global layout is done.

**What is next:** Homepage, product pages, category pages, and cart. Match these to your design prototypes.

---

## 3. The Customization Workflow

Every theme change follows this loop:

### Step 1: Identify What You Want to Change

Ask three questions:

- Is this **CSS-only** (colors, spacing, fonts)? If yes, edit a `.css` file.
- Is this **HTML structure** (layout, new sections, reordering elements)? If yes, copy a `.cshtml` view.
- Is this **both**? If yes, do both.

### Step 2: Find the Source File

**For CSS:**

```bash
# Search for a class or style in the theme
grep -rn "menu__link" Themes/ArityTheme/Content/css/

# Or search the large styles.css
grep -n "your-class" Themes/ArityTheme/Content/css/styles.css
```

**For views:**

```bash
# Find which core view renders something
grep -rn "SomeTextOrClass" Views/

# List what is already overridden in your theme
ls Themes/ArityTheme/Views/

# Find widget zones (injection points)
grep -rn "widgetZone" Views/Shared/_Root.cshtml
```

### Step 3: Make the Change

**CSS-only change:**

```bash
# Edit the right modular file
# - Colors/spacing → arity.tokens.css
# - Typography/base → arity.base.css
# - Header/nav → arity.nav.css
# - Products/cards → arity.products.css
# - Footer → arity.footer.css
# - Icons → arity.icons.css
# - Legacy overrides → styles.css (bottom of file is safest)
```

**View override:**

```bash
# Copy from core to theme, keeping the same relative path
# Example: override the homepage
cp Views/Home/Index.cshtml Themes/ArityTheme/Views/Home/Index.cshtml

# Then edit the copied file
```

### Step 4: Build

```bash
cd ~/Developer/infrastructure/nopcommerce-src
dotnet build src/NopCommerce.sln
```

Wait for `Build succeeded. 0 Error(s)`.

### Step 5: Deploy

**Option A: Hot Copy (fast, 30 seconds, for CSS and view changes)**

```bash
dotnet publish src/Presentation/Nop.Web/Nop.Web.csproj -c Release -o /tmp/nop-publish
docker cp /tmp/nop-publish/Themes/ArityTheme db-infra-nopcommerce:/app/Themes/ArityTheme
docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*
docker restart db-infra-nopcommerce
```

**Option B: Full Docker Rebuild (slow, 2–3 minutes, needed for .csproj changes)**

```bash
docker build -t registry.arity.co.za/nopcommerce:my-test .
docker stop db-infra-nopcommerce && docker rm db-infra-nopcommerce
docker run -d --name db-infra-nopcommerce \
  --network infrastructure_default -p 8080:80 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e "ConnectionStrings__ConnectionString=Server=db-infra-sqlserver,1433;Database=nopcommerce;User Id=SA;Password=DevPassword123!;TrustServerCertificate=True;" \
  -e "ConnectionStrings__DataProvider=sqlserver" \
  registry.arity.co.za/nopcommerce:my-test
```

### Step 6: Verify with a Screenshot

```bash
# List Chrome tabs
node ~/.pi/agent/npm/node_modules/@howaboua/pi-skill-chrome-cdp/skills/chrome-cdp/scripts/cdp.mjs list

# Screenshot (use target ID from list)
node ~/.pi/agent/npm/node_modules/@howaboua/pi-skill-chrome-cdp/skills/chrome-cdp/scripts/cdp.mjs shot <TARGET> /tmp/my-change.png
```

### Step 7: Commit

```bash
git add src/Presentation/Nop.Web/Themes/ArityTheme/
git commit -m "theme: customize [what you changed]"
git push origin develop
```

---

## 4. CSS Architecture: How to Style Without Breaking Things

### The Modular System

Instead of one large `styles.css`, we split by concern:

| File | Purpose | Edit When... |
|------|---------|-------------|
| `arity.tokens.css` | Brand colors, fonts, spacing variables | You need a new color, font, or spacing token |
| `arity.base.css` | Global resets, body typography, link styles | You want to change base font, link color, or scrollbar |
| `arity.nav.css` | Header, search bar, menu, mobile nav | Header changes, menu styling, or search tweaks |
| `arity.products.css` | Product cards, category grids, PDP layout | Product listings, detail pages, or cart items |
| `arity.footer.css` | Footer layout and styling | Footer changes |
| `arity.icons.css` | Lucide SVG icon sizing, color overrides | Icon replacements or sizing |
| `styles.css` | Legacy DefaultClean base (8500+ lines) + overrides at bottom | You cannot find a modular hook for an override |

### How CSS Gets Loaded

```
Head.cshtml registers files in this order:
  1. Google Fonts (Inter)
  2. styles.css (or styles.rtl.css)
  3. arity.tokens.css
  4. arity.base.css
  5. arity.nav.css
  6. arity.icons.css
   7. arity.products.css
  8. arity.footer.css
```

Later files override earlier files (if selectors have equal specificity). Our modular files win over `styles.css`.

### The Specificity Trap

`styles.css` has very specific selectors like:

```css
.overview .add-to-wishlist-button { background-image: url(wishlist-button.png); }
```

If you write:

```css
.add-to-wishlist-button { background-image: none; }
```

It **will not work**. The old selector is more specific.

**Fix:** Match the specificity exactly:

```css
.overview .add-to-wishlist-button { background-image: none !important; }
```

Or use the same selector chain:

```css
.overview .add-to-wishlist-button {
  background-image: none !important;
  /* your new styles */
}
```

### Direction-Aware Styling (RTL Safety)

**Never** use `margin-left`, `padding-right`, `border-left`, or `text-align: left` in Arity modular files.

| Instead of... | Use... |
|-------------|--------|
| `margin-left: 10px` | `margin-inline-start: 10px` |
| `padding-right: 20px` | `padding-inline-end: 20px` |
| `border-left: 1px solid` | `border-inline-start: 1px solid` |
| `text-align: left` | `text-align: start` |
| `left: 0` | `inset-inline-start: 0` |

This ensures the theme works for RTL languages. You do not need separate `.rtl.css` files for our custom modules.

### Adding a New CSS File

1. Create the file: `Themes/ArityTheme/Content/css/arity.whatever.css`
2. Register it in `Views/Shared/Head.cshtml`:

   ```csharp
   NopHtml.AppendCssFileParts($"~/Themes/{themeName}/Content/css/arity.whatever.css");
   ```

3. Build and deploy.

---

## 5. View Override Patterns

### Pattern A: Override a Shared Partial

Use this for: header, footer, head, product box (appears on many pages).

```bash
# Find the file in core views
cp Views/Shared/_Header.cshtml Themes/ArityTheme/Views/Shared/_Header.cshtml

# Edit the theme copy
# Build, deploy, verify
```

### Pattern B: Override a Page-Specific View

Use this for: homepage, product detail, category page, cart.

```bash
# Homepage
cp Views/Home/Index.cshtml Themes/ArityTheme/Views/Home/Index.cshtml

# Product detail
cp Views/Product/ProductDetails.cshtml Themes/ArityTheme/Views/Product/ProductDetails.cshtml

# Category page
cp Views/Catalog/CategoryTemplate.ProductsInGridOrLines.cshtml \
   Themes/ArityTheme/Views/Catalog/CategoryTemplate.ProductsInGridOrLines.cshtml

# Cart
cp Views/ShoppingCart/Cart.cshtml Themes/ArityTheme/Views/ShoppingCart/Cart.cshtml
```

### Pattern C: Override a Component View

Use this for: header links, search box, main menu, footer menu.

```bash
# Header links (wishlist, account, logout)
cp Views/Shared/Components/HeaderLinks/Default.cshtml \
   Themes/ArityTheme/Views/Shared/Components/HeaderLinks/Default.cshtml

# Search box
cp Views/Shared/Components/SearchBox/Default.cshtml \
   Themes/ArityTheme/Views/Shared/Components/SearchBox/Default.cshtml

# Main menu (category navigation)
cp Views/Shared/Components/MainMenu/Default.cshtml \
   Themes/ArityTheme/Views/Shared/Components/MainMenu/Default.cshtml
```

### Pattern D: Add a Widget Zone

Widget zones are no-code injection points. You can drop content into them from the admin panel without editing views.

```razor
<!-- In any .cshtml file, add a widget zone -->
@await Component.InvokeAsync(typeof(WidgetViewComponent), new { widgetZone = PublicWidgetZones.HomePageTop })
```

Key zones:

- `PublicWidgetZones.HomePageTop` — above homepage content
- `PublicWidgetZones.HomePageBottom` — below homepage content
- `PublicWidgetZones.ContentBefore` — before main content on any page
- `PublicWidgetZones.ContentAfter` — after main content on any page
- `PublicWidgetZones.ProductDetailsTop` — top of product page
- `PublicWidgetZones.ProductDetailsBottom` — bottom of product page

Full list: `src/Presentation/Nop.Web.Framework/Infrastructure/PublicWidgetZones.cs`

---

## 6. From Design Prototype to Theme View

Your design prototypes (`designs/redesign/*/code.html`) are **static HTML** using **Tailwind CSS CDN**. To bring them into nopCommerce:

### The Translation Process

1. **Open the prototype.** It is a complete HTML page with inline Tailwind classes.
2. **Identify the nopCommerce view** that renders the same page.
3. **Copy that view** to your theme.
4. **Preserve the Razor model.** Keep all `@model`, `@Html.*`, `Model.*`, and `@await Component.InvokeAsync` calls.
5. **Apply the HTML structure** from the prototype. Use Razor where data is dynamic.
6. **Convert Tailwind classes to CSS.** Add the styles to the appropriate `arity.*.css` file. Or keep Tailwind classes if you integrate Tailwind.

### Example: Translating a Product Card

**Prototype (from code.html):**

```html
<div class="bg-white rounded-lg shadow-sm p-4">
  <img src="product.jpg" class="w-full h-48 object-cover rounded-md">
  <h3 class="font-semibold text-lg mt-2">MacBook Pro</h3>
  <p class="text-gray-600">$1,999.00</p>
  <button class="bg-black text-white px-4 py-2 rounded mt-2">Add to Cart</button>
</div>
```

**nopCommerce view (_ProductBox.cshtml):**

```razor
@model ProductOverviewModel
<div class="product-item">
  <div class="picture">
    <a href="@Url.RouteUrl("Product", new { SeName = Model.SeName })">
      <img alt="@Model.DefaultPictureModel.AlternateText"
           src="@Model.DefaultPictureModel.ImageUrl"
           title="@Model.DefaultPictureModel.Title" />
    </a>
  </div>
  <div class="details">
    <h2 class="product-title">
      <a href="@Url.RouteUrl("Product", new { SeName = Model.SeName })">@Model.Name</a>
    </h2>
    <div class="add-info">
      @await Html.PartialAsync("_ProductPrice", Model.ProductPrice)
      @await Html.PartialAsync("_AddToCart", Model.AddToCart)
    </div>
  </div>
</div>
```

**Your job:** Keep the Razor model and helpers. Change the HTML structure and classes to match the prototype.

---

## 7. Common Tasks Cheat Sheet

### Change the Logo

```bash
# Replace the image file
cp your-logo.png Themes/ArityTheme/Content/images/logo.png
# Build and hot copy
```

### Change a Color

```bash
# Edit tokens
vim Themes/ArityTheme/Content/css/arity.tokens.css
# Update the CSS variable, for example:
# --arity-signal-red: #E63946;
# Build and hot copy
```

### Change the Homepage Layout

```bash
# Copy the homepage view
cp Views/Home/Index.cshtml Themes/ArityTheme/Views/Home/Index.cshtml
# Edit the theme copy
# Build, hot copy, and screenshot
```

### Add a New Font

```bash
# 1. Add Google Fonts link in Head.cshtml
NopHtml.AppendCssFileParts("https://fonts.googleapis.com/css2?family=YourFont&display=swap");

# 2. Update arity.tokens.css
--arity-font-main: 'YourFont', sans-serif;

# 3. Update arity.base.css
body { font-family: var(--arity-font-main); }
```

### Replace an Icon (PNG → Lucide SVG)

```bash
# 1. Find the old icon selector in styles.css
grep -n "wishlist-button" Themes/ArityTheme/Content/css/styles.css

# 2. In arity.icons.css, add:
.add-to-wishlist-button {
  background-image: none !important;
  /* Lucide SVG is injected via the view or JS */
}

# 3. Update the view that renders the button
# 4. Build and hot copy
```

### Stale CSS After Deploy

```bash
# WebOptimizer caches bundles. Always clear:
docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*
docker restart db-infra-nopcommerce
```

### Revert a Broken Change

```bash
# Delete the overridden view from the theme
rm Themes/ArityTheme/Views/Some/File.cshtml
# Core fallback kicks in automatically
# Build and hot copy
```

---

## 8. Safety Rules (The "Do Not" List)

| Do not | Because |
|-------|---------|
| Edit `Views/` (core) directly | You will lose edits on nopCommerce updates |
| Edit `Themes/DefaultClean/` | It is your reference copy. Keep it pristine |
| Forget `styles.rtl.css` | RTL users see broken styles |
| Use `left`/`right` in modular CSS | Breaks RTL. Use `inline-start`/`inline-end` |
| Skip the bundle cache clear | Stale CSS will cause false results |
| Change multiple surfaces at once | Hard to debug. One surface per deploy |
| Forget to build before deploying | Errors only show on build |
| Use `!important` unless necessary | Makes debugging harder. Match specificity instead |

---

## 9. Quick Reference: Files You Will Touch Most Often

| Task | File(s) |
|------|---------|
| Change colors/fonts/spacing | `arity.tokens.css` |
| Change body/typography | `arity.base.css` |
| Change header/search/menu | `arity.nav.css` + `_Header.cshtml` |
| Change product cards | `arity.products.css` + `_ProductBox.cshtml` |
| Change product detail page | `Product/ProductDetails.cshtml` + `arity.products.css` |
| Change category page | `Catalog/CategoryTemplate.*.cshtml` + `arity.products.css` |
| Change cart | `ShoppingCart/Cart.cshtml` + `arity.products.css` |
| Change footer | `arity.footer.css` |
| Add or remove CSS files | `Views/Shared/Head.cshtml` |
| Change page skeleton | `Views/Shared/_Root.cshtml` |
| Change <head> content | `Views/Shared/_Root.Head.cshtml` |
| Change meta/title/scripts | `Views/Shared/_Root.Head.cshtml` |

---

## 10. Your Design Prototypes → Views Mapping

| Prototype | Design File | Likely nopCommerce View to Override |
|-----------|-------------|-------------------------------------|
| Homepage | *(not yet in designs)* | `Views/Home/Index.cshtml` |
| Category (Cell Phones) | `designs/redesign/arity_shop_cell_phones_category_page/code.html` | `Views/Catalog/CategoryTemplate.ProductsInGridOrLines.cshtml` |
| Category (Books) | `designs/redesign/arity_shop_books_category_page/code.html` | `Views/Catalog/CategoryTemplate.ProductsInGridOrLines.cshtml` |
| Product Detail (MacBook Pro) | `designs/redesign/arity_shop_apple_macbook_pro_detail_page/code.html` | `Views/Product/ProductDetails.cshtml` + `Views/Product/_ProductDetails.cshtml` |
| Shopping Cart | `designs/redesign/arity_shop_shopping_cart_redesign/code.html` | `Views/ShoppingCart/Cart.cshtml` |

---

## 11. Next Steps to Get Good

1. **Make one small CSS change.** For example, change `--arity-signal-red` to a different red. Deploy it using the hot copy workflow. Verify with a screenshot.

2. **Override one view.** Copy `Views/Home/Index.cshtml` to the theme. Add a simple HTML comment. Deploy and verify the comment appears in the page source.

3. **Translate one prototype section.** Take the product card HTML from `code.html`. Adapt `_ProductBox.cshtml` to match the structure. Keep the Razor model.

4. **Read the design system.** Open `Design.md` and `arity.tokens.css` side by side. Understand how tokens map to CSS variables.

5. **Master the feedback loop.** Your power is the 30-second hot copy + screenshot cycle. The faster you iterate, the better your theme will be.

---

*This playbook is a living document. Update it as you learn new patterns.*
