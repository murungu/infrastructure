# ArityTheme — UI Review & Gap Analysis

> **Date:** 2026-08-01
> **URL reviewed:** <http://localhost:8080>
> **Viewports:** 375px, 768px, 1280px
> **Theme:** ArityTheme (modular CSS, Lucide SVG icons, single-row sticky header)

---

## Executive Summary

The ArityTheme structure is solid: header, footer, nav, product grid, cart, login, and PDP are all wired correctly. The CSS modular system (`arity.*.css`) is loading and RTL-safe logical properties are in place. **No layout is broken.** The remaining work is **content, data, and branding** — not structural theming.

**Launch readiness:** ~70%. The 30% gap is sample data cleanup, legal pages, and brand voice.

---

## P0 — CRITICAL (Launch Blockers)

| # | Gap | Page | Evidence | Fix |
|---|---|---|---|---|
| 1 | **Privacy Policy is a 404** | Footer → "Privacy notice" | Screenshot shows "Page not found" | Create a Topic page in admin (Content Management → Topics) with SystemName `PrivacyInfo`. Or create a static CMS page. |
| 2 | **"Powered by nopCommerce" in footer** | All pages | Visible on every screenshot | Remove or replace in `_Footer.cshtml` override or via CSS `display: none` |
| 3 | **"Your store" in page titles** | All pages | Browser tab shows "Your store. Home page title" | Admin → Configuration → Settings → General Settings → Store Name = "Arity Store" or "Arity Shop" (decision pending) |
| 4 | **Copyright says "Arty Store"** | Footer | "Copyright © 2026 Arty Store" | Fix in admin or footer view: "Arty Store" → "Arity Solutions" or the chosen store name |

---

## P1 — HIGH (User Experience & Brand)

| # | Gap | Page | Evidence | Fix |
|---|---|---|---|---|
| 5 | **Homepage welcome text is default nopCommerce** | Homepage | "Welcome to our store" + "Online shopping is the process consumers go through..." | Write Arity-branded welcome copy in admin → Content Management → Topics → `HomePageText` |
| 6 | **Product images are generic sample data** | Homepage, Category, PDP | iPhones, MacBooks, HTC phones, gift cards | Replace with Arity product photography (solar panels, batteries, inverters). Use the nano-banana-images skill. |
| 7 | **Category images are generic** | Homepage category blocks, Category page | Apparel model, phones, CDs | Replace with Arity category images. |
| 8 | **Product descriptions are generic IBM copy** | PDP | "Fight back against cluttered workspaces with the stylish IBM zBC12..." | Write real product descriptions using the nopcommerce-product-descriptions skill. |
| 9 | **Reviews show "Some sample review"** | PDP | "This sample review is for the Build your own computer..." | Delete sample reviews in admin → Catalog → Product Reviews. Or replace with real ones. |
| 10 | **Social media icons don't link to Arity accounts** | Footer | Facebook, X, YouTube, Instagram icons present | Update footer links to Arity's real social URLs (or remove if not active) |
| 11 | **Login page has placeholder text** | Login | "About login / registration" + "Put your login / registration information here..." | Edit admin → Content Management → Topics → `LoginPageText` |
| 12 | **No related products on PDP** | Product Detail | `relatedProducts: 0` | Enable "Related products" in admin → Catalog → Products → Related products tab. Or add manually per product. |

---

## P2 — MEDIUM (Polish & Consistency)

| # | Gap | Page | Evidence | Fix |
|---|---|---|---|---|
| 13 | **Tags are sample data** | Category sidebar | "awesome", "cool", "nice", "book", "camera" | Remove sample tags or replace with Arity-relevant tags ("solar", "battery", "off-grid", "LiFePO4", "Zimbabwe", "Harare", "load-shedding") |
| 14 | **Category names don't match Arity brand** | Nav + Category | "Electronics", "Apparel", "Digital downloads", "Books", "Jewelry" | Rename categories in admin to Arity categories: "Solar Panels", "Batteries", "Inverters", "Charge Controllers", "Accessories". |
| 15 | **Logo alt text says "Arity Store"** | Header | `logoAlt: "Arity Store"` | Change to "Arity Shop" in `_Header.cshtml` or admin |
| 16 | **Search placeholder is generic** | Header | "Search store" | Change to "Search solar products..." or "Find your solar solution..." |
| 17 | **Empty cart page is bare** | Cart | Icon + "Your Shopping Cart is empty!" | Add a styled CTA: "Continue shopping" button, or featured products below the message |
| 18 | **Breadcrumb styling is default** | Category + PDP | Grey background, default nopCommerce style | Style in `arity.nav.css` to match Arity design (no background, cleaner typography) |
| 19 | **Product short description says "Build it"** | PDP | `shortDesc: "Build it"` | Write meaningful short descriptions for each product |
| 20 | **Footer "Information" links may 404** | Footer | "Shipping & returns", "About us", "Contact us" | Verify each link works. Create missing Topic pages in admin. |

---

## P3 — LOW (Nice to Have)

| # | Gap | Page | Evidence | Fix |
|---|---|---|---|---|
| 21 | **"Login with phone" button** | Login | Present but likely not configured | Remove if phone auth is not set up |
| 22 | **No SSL/security trust badges** | Checkout | N/A (checkout not reviewed) | Add trust badges (secure checkout, free returns) below "Add to Cart" on PDP |
| 23 | **Newsletter styling** | Footer | Simple input + SUBSCRIBE button | Style the newsletter form to match Arity's dark footer better |
| 24 | **Manufacturers list in sidebar** | Category | "Apple", "HP" | Remove or populate with real Arity suppliers |
| 25 | **No live chat or help widget** | All pages | N/A | Optional: add Intercom, Crisp, or WhatsApp widget |

---

## What's Working Well (Do Not Touch)

| Element | Status |
|---|---|
| **Header** | Sticky single-row, white background, Arity logo, search, icons — clean and functional |
| **Navigation** | 8 categories visible, responsive (collapses to "CATEGORIES" button on mobile) |
| **Product Grid** | 4-column desktop, 2-column tablet, 1-column mobile. Cards with image, title, rating, price, ADD TO CART |
| **Footer** | 4-column layout with Information, Customer service, My account, Follow us + Newsletter — good structure |
| **Icons** | Lucide SVG icons working (account, wishlist, cart, search) |
| **CSS Modular System** | `arity.tokens.css`, `arity.nav.css`, `arity.products.css`, `arity.footer.css` all loading correctly |
| **RTL Safety** | Logical properties (`inset-inline-end`, `text-align: start`, `margin-inline-start`) in place |
| **Responsive Breakpoints** | Layout adapts correctly at 375/768/1280 |
| **No Broken Images** | 0 broken images across all 10 pages tested |
| **Favicon** | 9 favicon variants present (multiple sizes for devices) |
| **Cart/Checkout Flow** | Cart page renders, login page renders, checkout path exists |
| **PDP Structure** | Image gallery, thumbnails, variants, price, Add to Cart, wishlist, compare, email — all present |

---

## Recommended Priority Order

**Week 1 — P0 Blockers**

1. Fix store name + copyright in admin (10 min)
2. Create Privacy Policy Topic page (30 min)
3. Remove "Powered by nopCommerce" (15 min)

**Week 2 — P1 Content**
4. Write Arity homepage welcome text (1 hour)
5. Rename categories to solar/renewable energy terms (30 min)
6. Write product descriptions for top 10 products (3 hours — use nopcommerce-product-descriptions skill)
7. Generate product images for top 10 products (use nano-banana-images skill)
8. Fix social media links in footer (15 min)

**Week 3 — P2 Polish**
9. Clean up tags (30 min)
10. Style breadcrumb (1 hour)
11. Add related products (1 hour)
12. Improve empty cart page (1 hour)

**Week 4 — P3 Optional**
13. Add trust badges (30 min)
14. Style newsletter form (1 hour)
15. Add live chat widget (optional)

---

## How to Execute

Most P0 and P1 fixes are **admin panel tasks** — no code changes needed. The remaining theming work is minimal because the structural CSS is done.

**Content-heavy tasks** (product descriptions, images, category names) should use the existing Pi skills:

- `nano-banana-images` for product photography
- `nopcommerce-product-descriptions` for SEO-rich descriptions

**Page creation** (Privacy Policy, About Us, Contact Us) can be done via:

- Admin → Content Management → Topics (for simple pages)
- Admin → Content Management → Pages (for full CMS pages)

**Zimbabwe-specific notes:**

- Currency: USD (primary transactional currency in Zimbabwe)
- Payments: EcoCash mobile money (55%), USD Cash (20%), Cards (12%), Bank Transfer (8%)
- Shipping: Harare $3-7, Bulawayo $5-10, rural $10-25 USD
- Tax: 15% VAT, 2% IMTT on electronic transactions
- Legal: Cyber Security and Data Protection Act (2021), Consumer Protection Act (2019)
- COD (Cash on Delivery) is important for first-time buyer trust

---

*Review conducted via Playwright automated screenshot capture across 10 page types at 3 viewport widths. All screenshots saved to `/tmp/review-*.png`.*
