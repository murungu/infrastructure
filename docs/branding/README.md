# Arity Brand & Theming Documentation

> Central hub for all Arity Shop branding, design system, theming, and deployment docs.
> This lives in the `infrastructure` repo, **not** in `nopcommerce-src/` — keeping our branding separate from core nopCommerce code.

---

## What's Here

| Document | Purpose | Source of Truth |
|---|---|---|
| [theme-guide.md](theme-guide.md) | How to work with ArityTheme (modular CSS, WebOptimizer, override rules) | Code + this doc |
| [theme-playbook.md](theme-playbook.md) | Step-by-step theme creation, installation, activation | Code + this doc |
| [viewport-plan.md](viewport-plan.md) | Breakpoint discipline, screenshot matrix (375/768/1280), token source of truth | `Design.md` in nopcommerce-src |
| [ui-gaps.md](ui-gaps.md) | Live UI review findings — what's done, what's missing, prioritized | Screenshots + admin panel |
| [deployment.md](deployment.md) | Deploy to production via Docker | `infrastructure/docker-compose.yml` |
| [backup-restore.md](backup-restore.md) | Database backup/restore procedures | `docker-compose.yml` |

---

## Screenshots

Captured UI states are stored by date under `../screenshots/`:

```
screenshots/
├── 2026-08-01/   # ← Current review
│   ├── review-homepage.png
│   ├── review-category.png
│   ├── review-product-detail.png
│   ├── review-cart.png
│   ├── review-login.png
│   ├── ...
│   ├── check-homepage-{375,768,1280}.png
│   ├── infra-{375,768,1280}.png
│   └── electronics-{375,768,1280}.png
```

**Naming convention:**

- `review-{page}.png` — Full page type coverage (10 pages)
- `check-homepage-{width}.png` — Homepage at specific viewport
- `infra-{width}.png` — Infrastructure DB instance screenshots
- `electronics-{width}.png` — Electronics DB instance screenshots

**When to add new screenshots:**

- After every significant CSS change
- Before/after PR merges
- When verifying viewport breakpoints

---

## Quick Reference

### Test URLs

| Instance | URL | Database | Products |
|---|---|---|---|
| Infrastructure | <http://localhost:8080> | PostgreSQL `nopcommerce_infra` | 50 (Arity renewable energy) |
| Electronics | <http://localhost:8083> | PostgreSQL `nopcommerce_electronics` | Sample data |

### Theme Files (in `nopcommerce-src/`)

```
nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/
├── Content/css/
│   ├── arity.tokens.css      # Design tokens
│   ├── arity.base.css        # Reset + base styles
│   ├── arity.nav.css         # Header + nav
│   ├── arity.icons.css       # Lucide SVG icons
│   ├── arity.products.css    # Product grid + PDP
│   └── arity.footer.css      # Footer
├── Views/Shared/
│   ├── _Header.cshtml        # Header override
│   ├── _Footer.cshtml        # Footer override
│   └── Head.cshtml           # CSS loading order
└── ...
```

### Custom Pi Skills

| Skill | Location | Purpose |
|---|---|---|
| `nopcommerce-product-descriptions` | `~/.pi/agent/skills/nopcommerce-product-descriptions/SKILL.md` | Generate SEO-rich product descriptions |
| `nano-banana-images` | `~/.pi/agent/skills/nano-banana-images/SKILL.md` | Generate product images via API |
| `ste-writer` | `~/.pi/agent/skills/ste-writer/SKILL.md` | STE100 compliance checking |

---

## Contributing

1. **Never commit to `main` or `develop` directly** — use feature branches + PRs
2. **Update this index** when adding new docs
3. **Store screenshots** in `../screenshots/YYYY-MM-DD/` with descriptive names
4. **Keep docs in STE100 Simplified Technical English** where possible

---

*Last updated: 2026-08-01*
