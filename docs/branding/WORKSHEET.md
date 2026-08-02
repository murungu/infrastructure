# Arity Shop — Production Worksheet

> **Living document:** Scope, sequence, and status of all work needed before Zimbabwe production launch.
> **Last updated:** 2026-08-02
> **Launch market:** Zimbabwe (first), with USD pricing
> **Store name:** Decision pending — "Arity Store" vs "Arity Shop"

---

## How to Use This Document

1. **Pick a section** that matches what you are working on.
2. **Read the Blockers** first — nothing ships until these are resolved.
3. **Check Dependencies** — some tasks must happen before others.
4. **Update status** when you complete a task. Commit the change.

---

## Section Overview

| Section | What it covers | Status |
|---|---|---|
| [Blockers](#blockers) | Things that prevent launch | 0/6 complete |
| [Store Name Decision](#store-name-decision) | "Arity Store" vs "Arity Shop" | Decision pending |
| [Legal Pages](#legal-pages) | Privacy, Terms, About Us, Shipping, Returns, Cookies | 0/6 complete |
| [Mobile UX](#mobile-ux) | Issues found at 375px viewport | 0/6 complete |
| [Branding](#branding) | Store name, copyright, footer, social links | 0/4 complete |
| [Content](#content) | Product descriptions, images, categories, homepage | 0/5 complete |
| [Theme Polish](#theme-polish) | Breadcrumb, empty cart, related products, tags | 0/4 complete |
| [Infrastructure](#infrastructure) | SSL, domain, production DB, monitoring | 0/4 complete |
| [Post-Launch](#post-launch) | Analytics, SEO, performance, support | 0/4 complete |

---

## Zimbabwe Market Context

| Factor | Detail | Impact on Store |
|---|---|---|
| **Currency** | USD (primary transactional) | All prices in USD. No ZiG. |
| **Payments** | EcoCash (55%), USD Cash (20%), Cards (12%), Bank Transfer (8%) | Must support EcoCash. COD important for trust. |
| **VAT** | 15% standard rate | Display VAT-inclusive pricing. Issue tax invoices. |
| **IMTT** | 2% on electronic transactions | Factor into pricing or absorb. |
| **Shipping** | Harare $3-7, Bulawayo $5-10, rural $10-25 USD | Display shipping costs upfront. |
| **Trust** | COD still important for first-time buyers | Offer COD option. WhatsApp sales are huge. |
| **Commerce growth** | Formal ecommerce growing at 20-25% | Mobile-first is critical. |
| **Legal** | Cyber Security and Data Protection Act (2021), Consumer Protection Act (2019) | Privacy Policy required. Terms of Use required. |

---

## Blockers

These must all be resolved before the store goes to production in Zimbabwe.

| # | Blocker | Why it blocks | How to fix | Effort | Status |
|---|---|---|---|---|---|
| B1 | **Privacy Policy is a 404** | Legal requirement (Cyber Security and Data Protection Act 2021). Footer link hits "Page not found". | Create Topic page in admin. See [Legal Pages](#legal-pages) section. | 2 h | ❌ |
| B2 | **Terms of Use is default nopCommerce text** | Legal exposure. Generic text does not reflect Arity business or Zimbabwe law. | Rewrite in admin. See [Legal Pages](#legal-pages) section. | 2 h | ❌ |
| B3 | **"Powered by nopCommerce" in footer** | Looks unprofessional. Removes credibility. | Edit `_Footer.cshtml` or CSS `display: none`. | 15 min | ❌ |
| B4 | **Store name undecided** | Cannot finalize branding, SEO, email templates, legal documents until name is chosen. | See [Store Name Decision](#store-name-decision) section. | 30 min | ❌ |
| B5 | **"Your store" in page titles** | Browser tabs, search results, emails all show wrong name. | Admin → Settings → General → Store Name = chosen name. | 5 min | ❌ |
| B6 | **Copyright says "Arty Store"** | Wrong company name. | Fix in admin or footer view. | 5 min | ❌ |

**Blocker dependency:** B3, B5, B6 can be done immediately once B4 is decided. B1 and B2 need legal text drafted first.

---

## Store Name Decision

**Current status:** Undecided. Two candidates under consideration.

### Candidate: "Arity Store"

| Pros | Cons |
|---|---|
| Neutral and familiar. "Store" is universally understood across languages. | Generic. Does not convey e-commerce specifically. |
| Works for both online and physical retail if Arity expands. | Slightly less distinctive than "Shop". |
| Common in African markets ("Game Store", "OK Stores"). | May feel like a brick-and-mortar brand to online-first users. |
| Easy to pronounce and spell. | Does not immediately signal "buy online here". |

### Candidate: "Arity Shop"

| Pros | Cons |
|---|---|
| Immediately signals e-commerce and online buying. | Less flexible if Arity opens physical locations later. |
| More distinctive and modern. "Shop" implies curation and selection. | May feel too casual for B2B solar installations. |
| Aligns with global e-commerce naming ("Amazon Shop", "Shopify"). | Less common in Zimbabwean retail naming conventions. |
| Slightly more memorable. | Could be confused with "workshop" in some contexts. |

### Recommendation

**"Arity Store"** is recommended for the Zimbabwe launch if:

- Arity may expand to physical retail or B2B services later.
- You want a name that works across all touchpoints (online, WhatsApp, physical).
- You prefer familiarity over modernity in the Zimbabwe market.

**"Arity Shop"** is recommended if:

- The business is online-only for the foreseeable future.
- You want to signal e-commerce immediately to first-time visitors.
- You are targeting a younger, more digital-first audience.

**Hybrid option:** Use "Arity Store" as the legal/brand name, but tagline as "Arity Store — Your Solar Shop" to get both signals.

### What we need to decide

- [ ] Pick one: **Arity Store** or **Arity Shop**
- [ ] Document decision in this file
- [ ] Update all references across the codebase
- [ ] Register domain name (`aritystore.co.zw` or `arityshop.co.zw`)

---

## Legal Pages

### Current State

| Page | nopCommerce Status | Arity Status | How to Access |
|---|---|---|---|
| **Privacy Policy** | Topic exists (`PrivacyInfo`) but is **blank/404** | ❌ Not drafted | Admin → Content Management → Topics → `PrivacyInfo` |
| **Terms of Use** | Topic exists (`ConditionsOfUse`) with **default nopCommerce text** | ❌ Not rewritten | Admin → Content Management → Topics → `ConditionsOfUse` |
| **About Us** | Topic exists (`AboutUs`) with **default nopCommerce text** | ❌ Not rewritten | Admin → Content Management → Topics → `AboutUs` |
| **Shipping & Returns** | Topic exists (`ShippingInfo`) with **default nopCommerce text** | ❌ Not rewritten | Admin → Content Management → Topics → `ShippingInfo` |
| **Contact Us** | Topic exists (`ContactUs`) with **default nopCommerce text** | ❌ Not rewritten | Admin → Content Management → Topics → `ContactUs` |
| **Cookie Policy** | ❌ No topic exists | ❌ Not drafted | Admin → Content Management → Topics → Add new |

### What We Need

| # | Page | Required By | Content Source | Where to Create | Effort |
|---|---|---|---|---|---|
| L1 | **Privacy Policy** | Cyber Security and Data Protection Act (2021) | Arity legal team or privacy policy generator | Admin → Topics → `PrivacyInfo` | 2 h |
| L2 | **Terms of Use** | Contractual protection, Consumer Protection Act (2019) | Arity legal team or terms generator | Admin → Topics → `ConditionsOfUse` | 2 h |
| L3 | **Cookie Policy** | Data Protection Act cookie consent requirements | Short policy + consent mechanism | Admin → Topics → new `CookiePolicy` | 1 h |
| L4 | **Shipping & Returns** | Customer expectation, dispute protection | Arity operations team | Admin → Topics → `ShippingInfo` | 1 h |
| L5 | **About Us** | Brand trust, SEO | Arity marketing team | Admin → Topics → `AboutUs` | 1 h |
| L6 | **Contact Us** | Customer support channel | Arity operations team | Admin → Topics → `ContactUs` | 30 min |

### Zimbabwe Legal Context

| Requirement | Applies To | What it means for Arity Shop |
|---|---|---|
| **Cyber Security and Data Protection Act (2021)** | All Zimbabwean businesses | Must have Privacy Policy. Must explain what data is collected, why, how long stored, who has access. Must allow users to request deletion. Must report data breaches. |
| **Consumer Protection Act (2019)** | All Zim businesses selling to consumers | Must display Terms of Sale. Must allow returns within reasonable period. Must display pricing clearly. Cannot use unfair contract terms. |
| **VAT Act** | Businesses with turnover > threshold | Must display VAT-inclusive pricing. Must issue tax invoices. Register with ZIMRA if threshold met. Current VAT: 15%. |
| **IMTT (2%)** | Electronic transactions | 2% Intermediated Money Transfer Tax on mobile money and electronic payments. Factor into pricing or absorb. |
| **Exchange Control** | USD transactions | Ensure pricing and invoicing comply with Reserve Bank of Zimbabwe exchange control regulations. |

### Recommended Legal Page Structure

**Privacy Policy must include:**

1. What data we collect (name, email, phone, address, payment info)
2. How we collect it (forms, cookies, analytics)
3. Why we collect it (order fulfillment, marketing, legal compliance)
4. How long we keep it
5. Who we share it with (payment processors, shipping companies)
6. User rights (access, correction, deletion, objection)
7. How to contact us about privacy
8. Cookie usage and consent
9. **Zimbabwe-specific:** Reference to Cyber Security and Data Protection Act (2021)

**Terms of Use must include:**

1. Business identity (Arity Solutions, registration number, Zimbabwe address)
2. What the site sells (renewable energy products, USD pricing)
3. Pricing and payment terms (EcoCash, cash, card, bank transfer)
4. Shipping and delivery terms (Harare/Bulawayo/rural, USD costs)
5. Returns and refund policy (reasonable period under Consumer Protection Act)
6. Warranty information
7. Limitation of liability
8. Governing law (Zimbabwe)
9. **Zimbabwe-specific:** VAT disclosure, IMTT disclosure, exchange control compliance

### Draft Status

| Document | Location | Status | Owner |
|---|---|---|---|
| Privacy Policy draft | `docs/legal/privacy-policy-draft.md` | ❌ Not created | TBD |
| Terms of Use draft | `docs/legal/terms-of-use-draft.md` | ❌ Not created | TBD |
| Cookie Policy draft | `docs/legal/cookie-policy-draft.md` | ❌ Not created | TBD |
| Shipping & Returns draft | `docs/legal/shipping-returns-draft.md` | ❌ Not created | TBD |
| About Us draft | `docs/legal/about-us-draft.md` | ❌ Not created | TBD |

**Recommendation:** Create a `docs/legal/` directory with Markdown drafts. Review with Arity legal team. Then paste approved text into admin Topics.

---

## Mobile UX

From [mobile-first-audit.md](mobile-first-audit.md). All issues verified at 375px.

| # | Issue | Page | Fix | Effort | Status |
|---|---|---|---|---|---|
| M1 | **Sidebar blocks products on mobile** | Category | Move sidebar below product grid on `max-width: 768px`. Or hide Manufacturers/Tags. | 1 h | ❌ |
| M2 | **Product card action buttons too small** | Homepage, Category | Increase icon buttons to 44×44px. Stack vertically on mobile. | 1 h | ❌ |
| M3 | **Variant selectors dense on PDP** | Product Detail | Increase padding on `.attribute-list li`. Full-width dropdowns. `min-height: 44px` on inputs. | 1 h | ❌ |
| M4 | **Product description = wall of text** | Product Detail | Add `line-height: 1.6` to `.full-description`. Split into shorter paragraphs. | 30 min | ❌ |
| M5 | **Category images oversized on homepage** | Homepage | Reduce category image height to 120px on mobile. Or horizontal scroll. | 30 min | ❌ |
| M6 | **Breadcrumb wraps awkwardly** | Product Detail | Truncate with ellipsis on mobile. Or hide middle segments. | 30 min | ❌ |

**Mobile dependency:** M1, M2, M3 are structural and should be done together. M4, M5, M6 are cosmetic and can be done anytime.

---

## Branding

| # | Task | How to Fix | Effort | Status |
|---|---|---|---|---|
| BR1 | **Decide store name** | See [Store Name Decision](#store-name-decision) section | 30 min | ❌ |
| BR2 | **Fix store name in admin** | Admin → Configuration → Settings → General Settings → Store Name = chosen name | 5 min | ❌ |
| BR3 | **Fix copyright** | Admin → Configuration → Settings → General Settings → Footer text. Or edit `_Footer.cshtml`. | 5 min | ❌ |
| BR4 | **Remove "Powered by nopCommerce"** | Edit `_Footer.cshtml` or CSS `display: none` on `.footer-powered-by` | 15 min | ❌ |
| BR5 | **Fix social media links** | Edit `_Footer.cshtml`. Replace placeholder URLs with Arity real URLs. Or remove if not active. | 15 min | ❌ |

**Branding dependency:** BR1 must happen first. BR2–BR5 depend on the name choice.

---

## Content

| # | Task | How to Fix | Effort | Status | Skill Needed |
|---|---|---|---|---|---|
| C1 | **Write Arity homepage welcome text** | Admin → Content Management → Topics → `HomePageText`. Mention Zimbabwe, load-shedding, solar solutions. | 1 h | ❌ | None |
| C2 | **Rename categories** | Admin → Catalog → Categories. Rename "Electronics" → "Solar Panels", etc. | 30 min | ❌ | None |
| C3 | **Write product descriptions (top 10)** | Admin → Catalog → Products → Edit → Description. Use `nopcommerce-product-descriptions` skill. | 3 h | ❌ | `nopcommerce-product-descriptions` |
| C4 | **Generate product images (top 10)** | Use `nano-banana-images` skill. Upload to admin → Catalog → Products → Pictures. | 3 h | ❌ | `nano-banana-images` |
| C5 | **Delete sample reviews** | Admin → Catalog → Product Reviews → Delete "Some sample review" entries. | 15 min | ❌ | None |

**Content dependency:** C2 (categories) should happen before C3/C4 (products in those categories). C3 and C4 can happen in parallel.

**Product priority:** Top 10 products to describe/image first:

1. Solar panel (highest margin or most popular)
2. Battery (LiFePO4, 5kWh)
3. Battery (LiFePO4, 10kWh)
4. Inverter (solar hybrid)
5. Charge controller (MPPT)
6. Solar panel (second model)
7. Inverter (second model)
8. Battery accessory
9. Solar mounting kit
10. Solar cable/wiring kit

*(Priority to be confirmed by Arity business team)*

---

## Theme Polish

| # | Task | How to Fix | Effort | Status |
|---|---|---|---|---|
| P1 | **Style breadcrumb** | Add CSS to `arity.nav.css`. Remove grey background, cleaner typography. | 1 h | ❌ |
| P2 | **Improve empty cart page** | Add "Continue shopping" CTA button. Show featured products below. | 1 h | ❌ |
| P3 | **Add related products to PDP** | Admin → Catalog → Products → Related products tab. Or auto-populate by category. | 1 h | ❌ |
| P4 | **Clean up sample tags** | Admin → Catalog → Tags. Delete "awesome", "cool", "nice". Add "solar", "battery", "off-grid", "Zimbabwe", "Harare". | 30 min | ❌ |

**Polish dependency:** All independent. Can be done anytime after blockers.

---

## Infrastructure

| # | Task | How to Fix | Effort | Status |
|---|---|---|---|---|
| I1 | **Production database** | Provision managed PostgreSQL. Migrate from local. | 2 h | ❌ |
| I2 | **SSL certificate** | Let's Encrypt or Cloudflare. HTTPS only. | 1 h | ❌ |
| I3 | **Domain + DNS** | Point `shop.arity.co.zw` (or chosen domain) to production server. | 30 min | ❌ |
| I4 | **Production Docker Compose** | Copy `docker-compose.yml`. Update env vars. Add reverse proxy (Nginx/Caddy). | 2 h | ❌ |
| I5 | **Payment gateway integration** | EcoCash integration or PayNow Zimbabwe. Or manual bank transfer + WhatsApp confirmation. | 4 h | ❌ |
| I6 | **VAT invoicing** | Configure nopCommerce tax settings. Set 15% VAT. Ensure invoices show ZIMRA registration. | 2 h | ❌ |

**Infrastructure dependency:** I1 → I4 → I2 → I3 (roughly sequential). I5 and I6 can happen in parallel.

---

## Post-Launch

| # | Task | How to Fix | Effort | Status |
|---|---|---|---|---|
| PL1 | **Google Analytics** | Add GA4 tracking code to `_Root.Head.cshtml`. | 30 min | ❌ |
| PL2 | **SEO meta tags** | Add description, keywords, Open Graph to products and categories. | 2 h | ❌ |
| PL3 | **Performance monitoring** | Add Lighthouse CI or PageSpeed monitoring. | 1 h | ❌ |
| PL4 | **Support channel** | Add WhatsApp widget or contact form. | 1 h | ❌ |
| PL5 | **South Africa expansion** | Duplicate Zimbabwe setup. Add ZAR pricing option. Add local payment methods (Ozow, SnapScan). | 8 h | ❌ |

---

## Recommended Sequence

### Week 1: Blockers + Branding Decision (2 hours)

1. BR1: Decide store name ("Arity Store" vs "Arity Shop")
2. BR2: Fix store name in admin (5 min)
3. BR3: Fix copyright (5 min)
4. BR4: Remove "Powered by nopCommerce" (15 min)
5. BR5: Fix social links (15 min)
6. **Start legal drafts** — create `docs/legal/` directory, draft Privacy Policy and Terms of Use

### Week 2: Mobile UX (4 hours)

7. M1: Move sidebar below products (1 h)
2. M2: Increase touch targets (1 h)
3. M3: Fix variant selectors (1 h)
4. M4–M6: Cosmetic fixes (1 h combined)

### Week 3: Legal Pages Finalize (depends on legal review)

11. L1: Publish Privacy Policy (after legal review)
2. L2: Publish Terms of Use (after legal review)
3. L3–L6: Publish remaining legal pages

### Week 4: Content (6 hours)

14. C2: Rename categories (30 min)
2. C1: Write homepage text (1 h)
3. C3: Write product descriptions (3 h)
4. C4: Generate product images (3 h)
5. C5: Delete sample reviews (15 min)

### Week 5: Theme Polish (4 hours)

19. P1–P4: All polish items

### Week 6: Infrastructure (8 hours)

20. I1: Production database
2. I4: Production Docker Compose
3. I5: Payment gateway (EcoCash/PayNow)
4. I6: VAT invoicing setup
5. I2: SSL certificate
6. I3: Domain + DNS

### Week 7: Soft Launch

26. Internal testing with real orders
2. Fix bugs
3. Performance optimization

### Week 8: Public Launch

29. Announce
2. Monitor
3. Iterate

### Month 4: South Africa Expansion

32. Duplicate Zimbabwe setup
2. Add ZAR pricing
3. Add SA payment methods
4. Update legal pages for SA law (POPIA, CPA)

---

## Definition of Done (per task)

For every task in this worksheet, confirm before marking complete:

- [ ] Change is implemented (code or admin)
- [ ] Screenshots at 375/768/1280px look correct
- [ ] Change is committed on a feature branch
- [ ] PR is opened and reviewed
- [ ] PR is merged to `develop`
- [ ] This worksheet is updated (change Status to ✅)
- [ ] This worksheet is committed to `main`

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Legal review takes longer than expected | Medium | Delays launch by weeks | Start drafting immediately. Use generator as placeholder. |
| Product images from nano-banana API are inconsistent | Medium | Looks unprofessional | Use image-to-image editing for consistency. Accept AI limitations in copy. |
| Mobile fixes break desktop layout | Low | Regression | Screenshot all 3 widths before and after. Test on real devices. |
| Production DB migration fails | Low | Data loss | Full backup before migration. Test restore procedure. |
| nopCommerce upstream update conflicts with theme | Low | Theme breaks | Follow fork workflow. Test on staging before prod. |
| EcoCash integration is complex | Medium | Delays payment launch | Start with manual bank transfer + WhatsApp confirmation. Add EcoCash later. |
| Store name debate delays branding | Low | Everything waits on name | Set a deadline for decision. Default to "Arity Store" if no decision. |

---

*This is a living document. Update it as work progresses. Commit changes to `docs/branding/WORKSHEET.md`.*

*Last updated: 2026-08-02*
