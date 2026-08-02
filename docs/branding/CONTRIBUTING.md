# Contributing to Arity Shop

> How to make changes to the ArityTheme without breaking things.

---

## Rules

1. **Never commit to `main` or `develop` directly.** Use feature branches. PR → review → merge.
2. **Never edit core nopCommerce files.** Only edit files inside `Themes/ArityTheme/`.
3. **One surface per deploy.** Change only one thing at a time: header, or product grid, or cart — not all three.
4. **Screenshot at 3 widths before calling work done.** 375px / 768px / 1280px.
5. **Mobile-first.** New CSS has no media query by default. Then add `min-width` blocks for desktop.
6. **RTL-safe.** Use `margin-inline-start`, not `margin-left`. Use `text-align: start`, not `left`.
7. **Clear bundles after CSS changes.** `docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*`
8. **Keep docs in STE100.** Short sentences. No contractions. Imperative voice for procedures.
9. **Wireframe before CSS.** Every layout change needs a wireframe for each target viewport (375px / 768px / 1280px) before implementation. Create it in `docs/wireframes/`. Review it. Then write CSS.

---

## Wireframe-First Workflow

Every layout change follows this order:

1. **Identify** the issue in `mobile-first-audit.md` or `ui-gaps.md`
2. **Wireframe** the proposed layout at 375px / 768px / 1280px in `docs/wireframes/`
3. **Review** the wireframe — check touch targets, readability, fold position
4. **Implement** in `Themes/ArityTheme/` CSS and views
5. **Screenshot** at 375px / 768px / 1280px and compare with wireframe
6. **Commit** if screenshots match the wireframe

**Rule: No CSS without a wireframe.** Color and spacing tweaks that do not change layout are exempt.

## Workflow

### Start

```bash
cd ~/Developer/infrastructure/nopcommerce-src
git checkout develop
git pull origin develop

# For wireframe-only changes (docs branch)
git checkout -b docs/wireframes/what-you-are-designing

# For CSS/view changes (theme branch)
git checkout -b fix/theme/something-short
```

### Make the change

Edit files inside `Themes/ArityTheme/` only:

- CSS: `Content/css/arity.XXX.css`
- Views: `Views/Shared/XXX.cshtml`

### Build

```bash
dotnet build src/NopCommerce.sln
```

### Deploy (hot copy)

```bash
dotnet publish src/Presentation/Nop.Web/Nop.Web.csproj -c Release -o /tmp/nop-publish
docker cp /tmp/nop-publish/Themes/ArityTheme db-infra-nopcommerce:/app/Themes/ArityTheme
docker exec db-infra-nopcommerce rm -rf /app/wwwroot/bundles/*
docker restart db-infra-nopcommerce
```

### Verify

```bash
# Screenshot at 3 widths
node /path/to/screenshot-script.mjs http://localhost:8080/
```

Or manually in Chrome DevTools:

1. Toggle device toolbar
2. Select **iPhone X** (375px), **iPad** (768px), **Responsive 1280px**
3. Check: no horizontal scroll, buttons are tappable, text is readable

### Commit

```bash
git add src/Presentation/Nop.Web/Themes/ArityTheme/
git commit -m "theme: what you changed and why"
git push origin fix/theme/something-short
```

### Open PR

On GitHub, open a PR to merge into `develop`. Request review. Merge after approval.

---

## What needs a full rebuild (slow, 2–3 min)

Hot copy is sufficient for CSS and view changes. You need a full rebuild only when you:

- Add a new `.cshtml` file
- Modify a `.csproj` file
- Add or remove NuGet packages
- Change C# code

Full rebuild:

```bash
cd ~/Developer/infrastructure/nopcommerce-src
docker build -t registry.arity.co.za/nopcommerce:test .
docker stop db-infra-nopcommerce && docker rm db-infra-nopcommerce
docker run -d --name db-infra-nopcommerce \
  --network infrastructure_default -p 8080:80 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e "ConnectionStrings__ConnectionString=Host=db-infra-postgres;Port=5432;Database=nopcommerce_infra;Username=appuser;Password=DevPassword123!" \
  -e "ConnectionStrings__DataProvider=postgres" \
  registry.arity.co.za/nopcommerce:test
```

---

## Testing checklist

Before you open a PR, confirm:

- [ ] Wireframe exists in `docs/wireframes/` for this layout change
- [ ] Wireframe reviewed at 375px / 768px / 1280px
- [ ] Build succeeds: `dotnet build src/NopCommerce.sln` → `0 Error(s)`
- [ ] Screenshots at 375/768/1280 match the wireframe
- [ ] No horizontal scroll on mobile
- [ ] Touch targets are 44×44px or larger
- [ ] RTL logical properties used (no `left`/`right` in new CSS)
- [ ] Bundle cache cleared and verified
- [ ] Only `Themes/ArityTheme/` files changed (no core edits)

---

## Getting help

Read these docs in order:

1. [README.md](README.md) — Project overview and current state
2. [theme-playbook.md](theme-playbook.md) — How to make your first change
3. [theme-guide.md](theme-guide.md) — CSS architecture and specificity rules
4. [viewport-plan.md](viewport-plan.md) — Breakpoint discipline
5. [mobile-first-audit.md](mobile-first-audit.md) — Known mobile issues

---

*Last updated: 2026-08-02*
