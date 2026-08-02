# Arity Shop — Social Media Presence

> Social accounts needed for Arity Shop brand. Current status: none created.

---

## Current State

The ArityTheme footer shows placeholder social media icons (Facebook, X, YouTube, Instagram) that do not link to real Arity accounts. These are inherited from the DefaultClean theme.

| Platform | Icon in Footer | Account Exists | URL | Priority |
|---|---|---|---|---|
| **Facebook** | ✅ | ❌ No | TBD | High |
| **X (Twitter)** | ✅ | ❌ No | TBD | High |
| **YouTube** | ✅ | ❌ No | TBD | Medium |
| **Instagram** | ✅ | ❌ No | TBD | High |
| **LinkedIn** | ❌ | ❌ No | TBD | Medium |
| **TikTok** | ❌ | ❌ No | TBD | Low |
| **WhatsApp Business** | ❌ | ❌ No | TBD | **Critical** |

---

## Recommended Accounts (in priority order)

### 1. WhatsApp Business — CRITICAL

**Why:** WhatsApp is the dominant sales channel in Zimbabwe. Formal ecommerce is growing but WhatsApp-driven sales are already huge. A WhatsApp Business account allows:

- Product catalog sharing
- Quick replies for common questions
- Automated away messages
- Order confirmation and tracking
- Direct payment links (EcoCash, PayNow)

**What to do:**

1. Download WhatsApp Business app
2. Register with Arity Shop business number
3. Set up business profile (logo, description, hours)
4. Create product catalog (can import from nopCommerce)
5. Add WhatsApp button to website footer and PDP

**Link format:** `https://wa.me/[number]?text=Hi%20Arity%20Shop%2C%20I%20am%20interested%20in%20your%20solar%20products`

**Effort:** 2 hours setup + ongoing catalog maintenance

---

### 2. Facebook Page — HIGH

**Why:** Largest social platform in Zimbabwe. Good for:

- Product announcements
- Customer reviews
- Paid advertising (Facebook Ads targeting Zim)
- Event promotion (installations, demonstrations)

**What to do:**

1. Create Facebook Business Page: "Arity Shop"
2. Add category: "Shopping & Retail" → "Solar Energy Company"
3. Upload logo, cover photo, business info
4. Add shop section (can sync with nopCommerce)
5. Set up Facebook Pixel for tracking

**Link:** `https://facebook.com/arityshopzw` (suggested handle)

**Effort:** 2 hours setup

---

### 3. Instagram — HIGH

**Why:** Visual platform. Perfect for:

- Solar panel installations
- Before/after photos
- Product showcases
- Stories for promotions
- Reels for educational content (solar tips, load-shedding solutions)

**What to do:**

1. Create Instagram Business account
2. Link to Facebook Page
3. Upload logo, bio with link to shop
4. Post grid: product photos, installation shots, customer testimonials
5. Use Zimbabwe-relevant hashtags: `#solarpowerzimbabwe` `#loadshedding` `#harare` `#bulawayo` `#solarpanels` `#arityshop`

**Link:** `https://instagram.com/arityshopzw` (suggested handle)

**Effort:** 2 hours setup + content creation ongoing

---

### 4. X (Twitter) — HIGH

**Why:** Good for:

- Customer service (public, fast responses)
- Industry news and commentary
- Load-shedding updates ("Power out in Harare? Our batteries keep you running")
- Partnership announcements

**What to do:**

1. Create X account: `@arityshopzw`
2. Bio: "Arity Shop — Solar panels, batteries, inverters for Zimbabwe. Beat load-shedding. 🌞"
3. Pin tweet with shop link and best-selling product

**Link:** `https://x.com/arityshopzw`

**Effort:** 1 hour setup

---

### 5. YouTube — MEDIUM

**Why:** Educational content builds trust:

- "How to size your solar system for your home"
- "Understanding battery capacity (kWh vs Ah)"
- "Solar panel installation time-lapse"
- "Customer testimonial: 'No more load-shedding'"

**What to do:**

1. Create YouTube channel
2. Upload intro video (30 seconds)
3. Create playlist: "Solar Education"
4. Embed videos on product pages and homepage

**Link:** `https://youtube.com/@arityshopzw`

**Effort:** 3 hours setup + video production ongoing

---

### 6. LinkedIn — MEDIUM

**Why:** B2B solar installations, commercial projects:

- Corporate clients
- Government and NGO contracts
- Industry partnerships
- Hiring announcements

**What to do:**

1. Create LinkedIn Company Page
2. Category: "Renewable Energy"
3. Post case studies and project updates

**Link:** `https://linkedin.com/company/arity-shop`

**Effort:** 1 hour setup

---

### 7. TikTok — LOW (future)

**Why:** Younger audience. Fun, short-form content:

- "Day in the life of a solar installer"
- "Load-shedding hack: this battery kept my fridge running"
- Product unboxing and reviews

**What to do:**

1. Create TikTok Business account
2. Post 2–3 times per week
3. Use trending sounds with solar content

**Link:** `https://tiktok.com/@arityshopzw`

**Effort:** 1 hour setup + content creation ongoing

---

## How to Add Social Links to the Footer

Edit the `_Footer.cshtml` file in the theme:

```bash
# Find the footer view
cp ~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Views/Shared/_Footer.cshtml \
   ~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Views/Shared/_Footer.cshtml

# Edit the theme copy
vim ~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Views/Shared/_Footer.cshtml
```

Replace placeholder social links with real URLs:

```html
<!-- Social icons in footer -->
<div class="social">
  <a href="https://facebook.com/arityshopzw" target="_blank" aria-label="Facebook">
    <svg>...Facebook icon...</svg>
  </a>
  <a href="https://x.com/arityshopzw" target="_blank" aria-label="X">
    <svg>...X icon...</svg>
  </a>
  <a href="https://instagram.com/arityshopzw" target="_blank" aria-label="Instagram">
    <svg>...Instagram icon...</svg>
  </a>
  <a href="https://youtube.com/@arityshopzw" target="_blank" aria-label="YouTube">
    <svg>...YouTube icon...</svg>
  </a>
  <a href="https://wa.me/[number]" target="_blank" aria-label="WhatsApp">
    <svg>...WhatsApp icon...</svg>
  </a>
</div>
```

**Note:** Only add icons for accounts that exist. Remove or hide placeholders until accounts are created.

---

## Suggested Handles

| Platform | Handle | URL |
|---|---|---|
| Facebook | `arityshopzw` | `facebook.com/arityshopzw` |
| X | `@arityshopzw` | `x.com/arityshopzw` |
| Instagram | `arityshopzw` | `instagram.com/arityshopzw` |
| YouTube | `@arityshopzw` | `youtube.com/@arityshopzw` |
| LinkedIn | `arity-shop` | `linkedin.com/company/arity-shop` |
| TikTok | `@arityshopzw` | `tiktok.com/@arityshopzw` |
| WhatsApp | `+[263 number]` | `wa.me/[number]` |

**Register all handles simultaneously** to prevent squatters.

---

## Content Strategy (Basic)

### What to post

| Platform | Frequency | Content Type |
|---|---|---|
| WhatsApp | Daily | Product catalog, order updates, customer service |
| Facebook | 3x/week | Product posts, promotions, customer reviews, articles |
| Instagram | 3x/week | Product photos, installations, stories, reels |
| X | 2x/week | News, tips, customer service, industry commentary |
| YouTube | 1x/month | Educational videos, testimonials, product demos |
| LinkedIn | 2x/month | B2B content, case studies, hiring, partnerships |

### Hashtags for Zimbabwe

- `#solarpowerzimbabwe`
- `#loadshedding`
- `#solarpanels`
- `#harare`
- `#bulawayo`
- `#renewableenergy`
- `#offgrid`
- `#arityshop`
- `#zimsolar`
- `#greenenergy`

---

## Related Documents

- [WORKSHEET.md](WORKSHEET.md) — Social links task (BR4)
- [ui-gaps.md](ui-gaps.md) — Footer social icons gap
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to edit `_Footer.cshtml`

---

*Last updated: 2026-08-02*
