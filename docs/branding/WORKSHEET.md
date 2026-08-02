# Arity Shop — Production Worksheet

> **Living document:** Scope, sequence, and status of all work needed before production launch.
> **Last updated:** 2026-08-02
> **Launch target:** TBD — see Blockers section

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
| [Blockers](#blockers) | Things that prevent launch | 0/5 complete |
| [Legal Pages](#legal-pages) | Privacy, Terms, About Us, Shipping, Returns, Cookies | 0/6 complete |
| [Mobile UX](#mobile-ux) | Issues found at 375px viewport | 0/6 complete |
| [Branding](#branding) | Store name, copyright, footer, social links | 0/4 complete |
| [Content](#content) | Product descriptions, images, categories, homepage | 0/5 complete |
| [Theme Polish](#theme-polish) | Breadcrumb, empty cart, related products, tags | 0/4 complete |
| [Infrastructure](#infrastructure) | SSL, domain, production DB, monitoring | 0/4 complete |
| [Post-Launch](#post-launch) | Analytics, SEO, performance, support | 0/4 complete |

---

## Blockers

These must all be resolved before the store goes to production.

| # | Blocker | Why it blocks | How to fix | Effort | Status |
|---|---|---|---|---|---|
| B1 | **Privacy Policy is a 404** | Legal requirement (POPIA, GDPR). Footer link hits "Page not found". | Create Topic page in admin. See [Legal Pages](#legal-pages) section. | 2 h | ❌ |
| B2 | **Terms of Use is default nopCommerce text** | Legal exposure. Generic text does not reflect Arity business. | Rewrite in admin. See [Legal Pages](#legal-pages) section. | 2 h | ❌ |
| B3 | **"Powered by nopCommerce" in footer** | Looks unprofessional. Removes credibility. | Edit `_Footer.cshtml` or CSS `display: none`. | 15 min | ❌ |
| B4 | **Store name says "Your store"** | Browser tabs, search results, emails all show wrong name. | Admin → Settings → General → Store Name = "Arity Shop". | 5 min | ❌ |
| B5 | **Copyright says "Arty Store"** | Wrong company name. | Fix in admin or footer view. | 5 min | ❌ |

**Blocker dependency:** B3, B4, B5 can be done immediately. B1 and B2 need legal text drafted first.

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
| L1 | **Privacy Policy** | POPIA (South Africa), GDPR if EU customers | Arity legal team or privacy policy generator | Admin → Topics → `PrivacyInfo` | 2 h |
| L2 | **Terms of Use** | Contractual protection | Arity legal team or terms generator | Admin → Topics → `ConditionsOfUse` | 2 h |
| L3 | **Cookie Policy** | POPIA/GDPR cookie consent requirements | Short policy + consent mechanism | Admin → Topics → new `CookiePolicy` | 1 h |
| L4 | **Shipping & Returns** | Customer expectation, dispute protection | Arity operations team | Admin → Topics → `ShippingInfo` | 1 h |
| L5 | **About Us** | Brand trust, SEO | Arity marketing team | Admin → Topics → `AboutUs` | 1 h |
| L6 | **Contact Us** | Customer support channel | Arity operations team | Admin → Topics → `ContactUs` | 30 min |

### South Africa Legal Context

| Requirement | Applies To | What it means for Arity Shop |
|---|---|---|
| **POPIA** (Protection of Personal Information Act) | All South African businesses | Must have Privacy Policy. Must explain what data is collected, why, how long stored, who has access. Must allow users to request deletion. |
| **CPA** (Consumer Protection Act) | All SA businesses selling to consumers | Must display Terms of Sale. Must allow returns within reasonable period. Must display pricing clearly. |
| **ECTA** (Electronic Communications and Transactions Act) | Online stores | Electronic contracts are valid. Must provide record of transaction. Must identify business (registration number, address). |
| **VAT** | Businesses with turnover > R1M | Must display VAT-inclusive pricing. Must issue tax invoices. Must register with SARS if threshold met. |

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

**Terms of Use must include:**

1. Business identity (Arity Solutions, registration number, address)
2. What the site sells (renewable energy products)
3. Pricing and payment terms
4. Shipping and delivery terms
5. Returns and refund policy
6. Warranty information
7. Limitation of liability
8. Governing law (South Africa)

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
| BR1 | **Fix store name** | Admin → Configuration → Settings → General Settings → Store Name = "Arity Shop" | 5 min | ❌ |
| BR2 | **Fix copyright** | Admin → Configuration → Settings → General Settings → Footer text. Or edit `_Footer.cshtml`. | 5 min | ❌ |
| BR3 | **Remove "Powered by nopCommerce"** | Edit `_Footer.cshtml` or CSS `display: none` on `.footer-powered-by` | 15 min | ❌ |
| BR4 | **Fix social media links** | Edit `_Footer.cshtml`. Replace placeholder URLs with Arity real URLs. Or remove if not active. | 15 min | ❌ |

**Branding dependency:** BR1, BR2, BR3 are independent. BR4 needs Arity social media URLs from the business team.

---

## Content

| # | Task | How to Fix | Effort | Status | Skill Needed |
|---|---|---|---|---|---|
| C1 | **Write Arity homepage welcome text** | Admin → Content Management → Topics → `HomePageText` | 1 h | ❌ | None |
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
| P4 | **Clean up sample tags** | Admin → Catalog → Tags. Delete "awesome", "cool", "nice". Add "solar", "battery", "off-grid". | 30 min | ❌ |

**Polish dependency:** All independent. Can be done anytime after blockers.

---

## Infrastructure

| # | Task | How to Fix | Effort | Status |
|---|---|---|---|---|
| I1 | **Production database** | Provision managed PostgreSQL. Migrate from local. | 2 h | ❌ |
| I2 | **SSL certificate** | Let's Encrypt or Cloudflare. HTTPS only. | 1 h | ❌ |
| I3 | **Domain + DNS** | Point `shop.arity.co.za` (or chosen domain) to production server. | 30 min | ❌ |
| I4 | **Production Docker Compose** | Copy `docker-compose.yml`. Update env vars. Add reverse proxy (Nginx/Caddy). | 2 h | ❌ |

**Infrastructure dependency:** I1 → I4 → I2 → I3 (roughly sequential).

---

## Post-Launch

| # | Task | How to Fix | Effort | Status |
|---|---|---|---|---|
| PL1 | **Google Analytics** | Add GA4 tracking code to `_Root.Head.cshtml`. | 30 min | ❌ |
| PL2 | **SEO meta tags** | Add description, keywords, Open Graph to products and categories. | 2 h | ❌ |
| PL3 | **Performance monitoring** | Add Lighthouse CI or PageSpeed monitoring. | 1 h | ❌ |
| PL4 | **Support channel** | Add WhatsApp widget or contact form. | 1 h | ❌ |

---

## Recommended Sequence

### Week 1: Blockers + Branding (2 hours)

1. BR1: Fix store name (5 min)
2. BR2: Fix copyright (5 min)
3. BR3: Remove "Powered by nopCommerce" (15 min)
4. BR4: Fix social links (15 min)
5. **Start legal drafts** — create `docs/legal/` directory, draft Privacy Policy and Terms of Use

### Week 2: Mobile UX (4 hours)

6. M1: Move sidebar below products (1 h)
2. M2: Increase touch targets (1 h)
3. M3: Fix variant selectors (1 h)
4. M4–M6: Cosmetic fixes (1 h combined)

### Week 3: Legal Pages Finalize (depends on legal review)

10. L1: Publish Privacy Policy (after legal review)
2. L2: Publish Terms of Use (after legal review)
3. L3–L6: Publish remaining legal pages

### Week 4: Content (6 hours)

13. C2: Rename categories (30 min)
2. C1: Write homepage text (1 h)
3. C3: Write product descriptions (3 h)
4. C4: Generate product images (3 h)
5. C5: Delete sample reviews (15 min)

### Week 5: Theme Polish (4 hours)

18. P1–P4: All polish items

### Week 6: Infrastructure (6 hours)

19. I1–I4: Production setup

### Week 7: Soft Launch

20. Internal testing with real orders
2. Fix bugs
3. Performance optimization

### Week 8: Public Launch

23. Announce
2. Monitor
3. Iterate

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

---

*This is a living document. Update it as work progresses. Commit changes to `docs/branding/WORKSHEET.md`.*

*Last updated: 2026-08-02*
