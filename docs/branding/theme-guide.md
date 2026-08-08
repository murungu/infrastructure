# Arity Theme Development Guide

> Incremental guide for building a custom nopCommerce theme without touching the core system.

## nopCommerce Theme Architecture

### Where Themes Live

```
src/Presentation/Nop.Web/Themes/
├── DefaultClean/              # The default reference theme
│   ├── theme.json             # Theme metadata
│   ├── Content/
│   │   ├── css/
│   │   │   ├── styles.css     # Main stylesheet
│   │   │   ├── styles.rtl.css # RTL variant
│   │   │   └── print.css      # Print stylesheet
│   │   ├── images/            # Theme images
│   │   └── js/                # (optional) Theme-specific JS
│   └── Views/
│       ├── _ViewImports.cshtml
│       └── Shared/
│           └── Head.cshtml    # Injects theme CSS into <head>
```

### The Fallback Engine (Core Concept)

nopCommerce uses a **fallback view resolution** system. When rendering any page:

1. First, it looks for the view in `/Themes/{ActiveTheme}/Views/`
2. If NOT found there, it falls back to `/Views/` (the core views)
3. If your theme has a view with the **same path and filename**, it wins

**This means:**

- You only copy views you actually want to change
- Unchanged views automatically use the core version
- Upgrading nopCommerce is safe. Your theme overrides stay isolated.

### How the Theme CSS Gets Loaded

The core `_Root.Head.cshtml` renders a partial called `Head`:

```razor
@await Html.PartialAsync("Head")
```

Your theme's `Views/Shared/Head.cshtml` injects the stylesheet:

```razor
@{
    var themeName = await themeContext.GetWorkingThemeNameAsync();
    var supportRtl = await Html.ShouldUseRtlThemeAsync();
    NopHtml.AppendCssFileParts($"~/Themes/{themeName}/Content/css/styles{(supportRtl ? ".rtl" : "")}.css");
}
```

### theme.json Schema

```json
{
  "SystemName": "ArityTheme",
  "FriendlyName": "Arity Theme",
  "SupportRTL": true,
  "PreviewImageUrl": "~/Themes/ArityTheme/preview.jpg",
  "PreviewText": "Custom theme for Arity Solutions store"
}
```

| Property | Purpose |
|----------|---------|
| `SystemName` | Unique identifier, must match folder name |
| `FriendlyName` | Display name in admin dropdown |
| `SupportRTL` | Whether RTL stylesheet is available |
| `PreviewImageUrl` | Thumbnail shown in admin theme selector |
| `PreviewText` | Description shown in admin |

## Widget Zones (No-Code Extension Points)

nopCommerce provides **150+ widget zones** where you can inject content via plugins/widgets without modifying any view. Key zones for theme customization:

| Zone | Location |
|------|----------|
| `home_page_top` | Top of homepage |
| `home_page_bottom` | Bottom of homepage |
| `content_before` | Before main content area |
| `content_after` | After main content area |
| `header_before` | Before header |
| `header_after` | After header |
| `footer` | Footer area |
| `head_html_tag` | Inside `<head>` tag |
| `productdetails_top` | Top of product page |
| `productdetails_bottom` | Bottom of product page |

Full list: `src/Presentation/Nop.Web.Framework/Infrastructure/PublicWidgetZones.cs`

> **Homepage exception:** ArityTheme does not render `home_page_top`. Its `Views/Home/Index.cshtml` renders `_ArityHomepageHero.cshtml` instead. The remaining homepage zones are available.

## Activating Your Theme

1. Build the solution
2. Go to **Admin → Configuration → Settings → General Settings**
3. Under **Store Information**, select your theme from the **Default theme** dropdown
4. Save.

## Docker / Deployment Notes

Since your nopCommerce runs in Docker:

- Theme files live in source control (good - they travel with the repo)
- The Dockerfile builds the solution, including your theme
- Theme assets are served as static files from the published app
- No special Docker configuration needed - themes are first-class citizens

## Resources

- [Official Designer's Guide](https://docs.nopcommerce.com/en/developer/design/index.html)
- [Creating a Theme](https://docs.nopcommerce.com/en/developer/design/new-theme.html)
- [Customizing Themes](https://docs.nopcommerce.com/en/developer/design/customizing-theme.html)
- [Widget Zones Reference](https://github.com/nopSolutions/nopCommerce/blob/master/src/Presentation/Nop.Web.Framework/Infrastructure/PublicWidgetZones.cs)
- [Writing Widgets](https://docs.nopcommerce.com/en/developer/plugins/how-to-write-widget-for-nopCommerce.html)

## Lessons Learned (Working Notes)

### 1. Scope Discipline: One Change at a Time

The fastest way to break a theme session is to drift across multiple surfaces in a single deploy. Agree on the single surface first. Then deploy it, verify it, and move on.

### 2. CSS Specificity Is the Real Override Enemy

Copying a view and adding an icon is only half the job. The inherited `styles.css` and `styles.rtl.css` often have **more specific selectors** than our modular overrides (e.g., `.overview .add-to-wishlist-button`).

When replacing an icon:

- Add the new icon via the partial/HTML.
- **Also** add a `background-image: none !important` rule that matches the exact specific selector used by the old style.
- If a double-icon appears, use the browser DevTools to find the winning background-image rule and copy its selector.

### 3. Background Images Must Be Explicitly Removed

Default nopCommerce buttons (wishlist, compare, email-a-friend) use PNG background images, not inline icons. When we inject Lucide SVGs, the old PNGs remain unless we override them. **Always null the background image on the exact old selector.**

### 4. Hot Copy Workflow Is Reliable

For pure theme/CSS changes, the fastest loop is:

```bash
dotnet publish src/Presentation/Nop.Web/Nop.Web.csproj -c Release -o /tmp/nop-publish
docker cp /tmp/nop-publish/Themes/ArityTheme db-infra-nopcommerce:/app/Themes/ArityTheme
docker exec db-infra-nopcommerce sh -c "cp -R /app/Themes/ArityTheme/ArityTheme/* /app/Themes/ArityTheme/ 2>/dev/null || true"
docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*
docker restart db-infra-nopcommerce
```

Critical: WebOptimizer bundles the CSS. **Always clear `/app/wwwroot/bundles/*`** after CSS changes or stale styles will persist.

### 5. Screenshot-Driven Verification

Use the Chrome CDP helper to screenshot the exact page immediately after deploy. This catches cascade/specificity issues that a simple code review misses.

### 6. Border Radius Is a Brand Signal

For Arity, `border-radius: 0` on buttons and cards reads as engineered/precision. Rounded corners belong to softer consumer brands, not the Arity aesthetic.

### 7. Joined vs. Separate Buttons Are Context-Dependent

Grid cards benefit from a **closed/joined button bar** because the card is small and the actions feel like one unit. The PDP benefits from **separate bordered buttons** because the page has room and each action needs its own identity.

## Modular CSS Architecture

ArityTheme uses modular CSS for maintainability and LTR/RTL support. Shared CSS modules load through `Head.cshtml`. Homepage assets load through `Views/Home/Index.cshtml`.

### CSS Files

- `arity.tokens.css`: Colors, fonts, and spacing variables.
- `arity.base.css`: Global body, typography, and link styles.
- `arity.nav.css`: Header and responsive category-menu styles.
- `arity.autocomplete.css`: Search-suggestion layout and focus states.
- `arity.hero.css`: Responsive homepage-hero layout. This file loads only on the homepage.
- `arity.icons.css`: Lucide SVG sizing and color overrides.
- `arity.products.css`: Product cards, category grids, and product details.
- `arity.footer.css`: Black Arity footer.
- `arity.forms.css`: Login, register, and shared form styles.
- `arity.custom.css`: Small isolated overrides.

### JavaScript Files

- `arity.menu.js`: Responsive category-menu behavior. `_Root.Head.cshtml` registers this shared file.
- `arity.hero.js`: Manual homepage-hero controls. `Views/Home/Index.cshtml` registers this page-only file.

### Direction-Aware Styling (RTL Support)

**Never** use hardcoded direction properties in Arity modular files. Always use **CSS Logical Properties**:

- Instead of `margin-left`, use `margin-inline-start`.
- Instead of `padding-right`, use `padding-inline-end`.
- Instead of `border-left`, use `border-inline-start`.
- Instead of `text-align: left`, use `text-align: start`.

This ensures that the theme automatically flips for RTL languages without needing separate `.rtl.css` files for our custom modules.
