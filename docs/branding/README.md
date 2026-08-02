# Arity Shop — Project Context (Start Here)

> **If you are an AI agent or a human jumping in:** Read this file first. It tells you what we are building, where we are, and how to work on it without asking questions.

---

## What We Are Building

A **renewable energy e-commerce store** for Arity Solutions. Products: solar panels, batteries, inverters, charge controllers.

- **Launch market:** Zimbabwe (first), with USD pricing
- **Currency:** USD (primary transactional currency in Zimbabwe)
- **Platform:** nopCommerce 4.x (forked), running in Docker
- **Theme:** ArityTheme — custom theme, modular CSS, mobile-first
- **Database:** PostgreSQL (local dev), managed PostgreSQL (production)
- **Deployment:** Docker image built by GitHub Actions, pushed to `registry.arity.co.za/nopcommerce`

---

## Current State (August 2026)

| Layer | Status | What it means |
|---|---|---|
| **Platform** | ✅ Done | Docker Compose runs PostgreSQL + Redis + nopCommerce. Builds from source. |
| **Theme structure** | ✅ Done | Modular CSS (`arity.*.css`), RTL-safe logical properties, Lucide SVG icons, sticky header, black footer. |
| **Responsive base** | ✅ Done | DefaultClean mobile-first behavior is intact. Verified at 375/768/1280px. |
| **Products in DB** | 🔄 Partial | 50 items exist but names/descriptions/images are generic sample data (iPhones, MacBooks). |
| **Mobile UX polish** | 🔄 Not started | Sidebar blocks products on mobile. Touch targets too small. Description text too dense. See [mobile-first-audit.md](mobile-first-audit.md). |
| **Branding** | 🔄 Partial | Logo, colors, footer are custom. But "Powered by nopCommerce" still shows. |
| **Legal pages** | ❌ Missing | Privacy Policy is a 404. Terms of Use exists but is default nopCommerce text. |
| **Content** | ❌ Missing | Homepage welcome text is default nopCommerce. Product descriptions are IBM copy. Reviews are sample data. |

**Launch readiness:** ~70%.

---

## How to Make a Theme Change (The 30-Second Loop)

```bash
# 1. Edit a CSS or view file
#    CSS:    ~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Content/css/arity.XXX.css
#    Views:  ~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Views/Shared/XXX.cshtml

# 2. Build
cd ~/Developer/infrastructure/nopcommerce-src
dotnet build src/NopCommerce.sln

# 3. Hot copy to running container (30 seconds)
dotnet publish src/Presentation/Nop.Web/Nop.Web.csproj -c Release -o /tmp/nop-publish
docker cp /tmp/nop-publish/Themes/ArityTheme db-infra-nopcommerce:/app/Themes/ArityTheme
docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*
docker restart db-infra-nopcommerce

# 4. Screenshot at 3 widths
npx playwright open http://localhost:8080
#    DevTools → Toggle device toolbar → iPhone X (375px)
#    DevTools → iPad (768px)
#    DevTools → Responsive 1280px

# 5. Commit on a feature branch
git checkout -b fix/theme/something
git add src/Presentation/Nop.Web/Themes/ArityTheme/
git commit -m "theme: what you changed and why"
git push origin fix/theme/something
# Open PR → merge to develop
```

**Never edit `Views/` (core nopCommerce). Never edit `Themes/DefaultClean/`.**

---

## What to Work On Next (Priority Order)

| Priority | Task | Why | Doc | Effort |
|---|---|---|---|---|
| 🔴 P0 | Fix store name + copyright in admin | "Your store" in titles, "Arty Store" in footer | [ui-gaps.md](ui-gaps.md) | 10 min |
| 🔴 P0 | Remove "Powered by nopCommerce" | Footer branding | [ui-gaps.md](ui-gaps.md) | 15 min |
| 🔴 P0 | Create Privacy Policy page | 404 on footer link. Legal requirement. | [ui-gaps.md](ui-gaps.md) | 30 min |
| 🟡 P1 | Move sidebar below products on mobile category | #1 mobile UX blocker | [mobile-first-audit.md](mobile-first-audit.md) | 1 h |
| 🟡 P1 | Increase touch targets on product cards | 72 elements fail 44×44px | [mobile-first-audit.md](mobile-first-audit.md) | 1 h |
| 🟡 P1 | Make PDP variant selectors more tappable | Dense radios/dropdowns on 375px | [mobile-first-audit.md](mobile-first-audit.md) | 1 h |
| 🟡 P1 | Write Arity homepage welcome text | Default nopCommerce text visible | [ui-gaps.md](ui-gaps.md) | 1 h |
| 🟢 P2 | Rename categories to solar/renewable terms | "Electronics" → "Solar Panels" etc. | [ui-gaps.md](ui-gaps.md) | 30 min |
| 🟢 P2 | Generate Arity product images | Use nano-banana-images skill | [ui-gaps.md](ui-gaps.md) | 3 h |
| 🟢 P2 | Write Arity product descriptions | Use nopcommerce-product-descriptions skill | [ui-gaps.md](ui-gaps.md) | 3 h |

---

## Documentation Index

Read these in order if you need depth on a topic:

| # | Document | Read when you need to... |
|---|---|---|
| 1 | **[mobile-first-audit.md](mobile-first-audit.md)** | Know what is broken on mobile and how to fix it. |
| 2 | **[ui-gaps.md](ui-gaps.md)** | Know the full UI review findings (desktop + mobile + branding + content). |
| 3 | **[viewport-plan.md](viewport-plan.md)** | Add a new breakpoint or media query. Understand the 375/768/1280 screenshot rule. |
| 4 | **[theme-playbook.md](theme-playbook.md)** | Make your first theme change. Find which file to edit. Learn the hot-copy loop. |
| 5 | **[DESIGN.md](DESIGN.md)** | Understand the color tokens, typography, and spacing system. Know how tokens map to CSS. |
| 6 | **[SOCIAL.md](SOCIAL.md)** | Know which social media accounts to create and how to add them to the footer. |
| 7 | **[theme-guide.md](theme-guide.md)** | Understand the modular CSS architecture, specificity rules, RTL safety. |
| 7 | **[deployment.md](deployment.md)** | Deploy to production. Understand the Docker image pipeline. |
| 8 | **[backup-restore.md](backup-restore.md)** | Back up or restore the database. |
| 9 | **[CONTRIBUTING.md](CONTRIBUTING.md)** | Contribution rules, PR workflow, testing checklist. |
| 10 | **[doc-audit-ste.md](doc-audit-ste.md)** | Check STE compliance of our docs. (Meta — rarely needed.) |

---

## Project Structure (Where Everything Lives)

### Repos

| Repo | Path | Purpose |
|---|---|---|
| **Infrastructure** | `~/Developer/infrastructure/` | Docker Compose, docs, automation. **This doc lives here.** |
| **nopCommerce source** | `~/Developer/infrastructure/nopcommerce-src/` | Application code. Theme files live here. |

### Key Files

```
# Design system (source of truth)
~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Design.md

# Theme CSS (edit these for styling)
~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Content/css/
├── arity.tokens.css       # Colors, fonts, spacing variables
├── arity.base.css         # Body, typography, links
├── arity.nav.css          # Header, search, menu
├── arity.icons.css        # Lucide SVG overrides
├── arity.products.css     # Product cards, grids, PDP
└── arity.footer.css       # Footer

# Theme views (edit these for HTML structure)
~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Views/Shared/
├── Head.cshtml            # CSS loading order
├── _Header.cshtml         # Site header
├── _Footer.cshtml         # Site footer
├── _ProductBox.cshtml     # Product card
└── _ArityIcon.cshtml      # Lucide icon helper

# Docker / deployment
~/Developer/infrastructure/docker-compose.yml
~/Developer/infrastructure/nopcommerce-src/Dockerfile
~/Developer/infrastructure/nopcommerce-src/.github/workflows/docker-build.yml

# Docs (this directory)
~/Developer/infrastructure/docs/branding/
```

### Test URLs

| Instance | URL | Database | Products | When to use |
|---|---|---|---|---|
| **Infrastructure** | <http://localhost:8080> | PostgreSQL `nopcommerce_infra` | 50 (Arity renewable energy) | Primary test instance |
| **Electronics** | <http://localhost:8083> | PostgreSQL `nopcommerce_electronics` | Sample data | Fallback / comparison |

### Admin Access

- **URL:** <http://localhost:8080/Admin>
- **Email:** `admin@arity.shop`
- **Password:** *(ask project owner — not stored in docs)*

---

## Tech Stack

| Layer | Technology |
|---|---|
| Platform | nopCommerce 4.x (.NET 8) |
| Theme CSS | Vanilla CSS with custom properties (design tokens) |
| Icons | Lucide SVG (inline, no icon font) |
| Database | PostgreSQL 15 (dev), managed PostgreSQL (prod) |
| Cache | Redis (optional, disabled during install) |
| Container | Docker + Docker Compose |
| CI/CD | GitHub Actions → `registry.arity.co.za/nopcommerce` |
| Screenshots | Playwright Chromium |

---

## Screenshot Archive

All screenshots live in `~/Developer/infrastructure/docs/screenshots/YYYY-MM-DD/`.

```
docs/screenshots/
├── 2026-08-01/          # Initial UI review
│   ├── review-homepage.png
│   ├── review-category.png
│   ├── review-product-detail.png
│   ├── review-cart.png
│   ├── review-login.png
│   ├── check-homepage-{375,768,1280}.png
│   ├── infra-{375,768,1280}.png
│   └── electronics-{375,768,1280}.png
└── 2026-08-02/          # Mobile-first audit
    ├── mobile-test-homepage-{mobile,tablet,desktop}.png
    ├── mobile-test-category-{mobile,tablet,desktop}.png
    ├── mobile-test-product-detail-{mobile,tablet,desktop}.png
    ├── mobile-test-cart-{mobile,tablet,desktop}.png
    └── mobile-test-login-{mobile,tablet,desktop}.png
```

**Naming convention:**

- `review-{page}.png` — Full page type coverage
- `mobile-test-{page}-{viewport}.png` — Mobile audit at specific width
- `check-homepage-{width}.png` — Viewport verification

**When to add new screenshots:**

- After every CSS change that affects layout
- Before/after PR merges
- When verifying breakpoint behavior

---

## Custom Pi Skills

These are pre-built skills for generating Arity content:

| Skill | File | Purpose |
|---|---|---|
| `nopcommerce-product-descriptions` | `~/.pi/agent/skills/nopcommerce-product-descriptions/SKILL.md` | Generate SEO-rich descriptions for solar/battery/inverter products |
| `nano-banana-images` | `~/.pi/agent/skills/nano-banana-images/SKILL.md` | Generate product photos via Nano Banana API |
| `ste-writer` | `~/.pi/agent/skills/ste-writer/SKILL.md` | Check docs for ASD-STE100 compliance |

---

## Rules for This Project

1. **Never commit to `main` or `develop` directly.** Use feature branches → PR → review → merge.
2. **Never edit core nopCommerce files.** Only edit files inside `Themes/ArityTheme/`.
3. **One surface per deploy.** Change only one thing at a time (header, or product grid, or cart — not all three).
4. **Screenshot at 3 widths before calling work done.** 375px / 768px / 1280px. No exceptions.
5. **Mobile-first.** New CSS has no media query by default. Then add `min-width` blocks for desktop.
6. **RTL-safe.** Use `margin-inline-start`, not `margin-left`. Use `text-align: start`, not `left`.
7. **Clear bundles after CSS changes.** `docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*`
8. **Keep docs in STE100 Simplified Technical English.** Short sentences. No contractions. Imperative voice for procedures.

---

*Last updated: 2026-08-02*
