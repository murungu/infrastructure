# Arity Design System

> Token source of truth for colors, typography, spacing, and shapes.
> The master file lives in the theme directory. This document explains how to use it.

---

## Where the tokens live

**Master file:**

```
~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Design.md
```

This file is the **source of truth** for the visual brand. It contains:

- Color ramp (primary, secondary, surface, error, outline)
- Typography scale (display, headline, body, label)
- Spacing values (margins, gutters, section gaps)
- Border radius scale
- Brand voice and aesthetic direction

**CSS token file:**

```
~/Developer/infrastructure/nopcommerce-src/src/Presentation/Nop.Web/Themes/ArityTheme/Content/css/arity.tokens.css
```

This file exposes a subset of the design tokens as CSS custom properties (`--arity-*`). Currently it has 8 colors. It needs to be expanded to cover the full ramp from `Design.md`.

---

## Color tokens (excerpt)

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#000000` | Buttons, headings, primary actions |
| `on-primary` | `#ffffff` | Text on primary backgrounds |
| `secondary` | `#b7102a` | Signal red — alerts, sale badges, CTAs |
| `on-secondary` | `#ffffff` | Text on secondary backgrounds |
| `surface` | `#f9f9fb` | Page background |
| `on-surface` | `#1a1c1d` | Body text |
| `surface-variant` | `#e2e2e4` | Cards, containers |
| `outline` | `#7e7576` | Borders, dividers |
| `error` | `#ba1a1a` | Validation errors |

Full ramp: open `Design.md` and read the `colors:` block.

---

## Typography tokens (excerpt)

| Token | Size | Weight | Line-height | Usage |
|---|---|---|---|---|
| `display-lg` | 48px | 700 | 56px | Hero headings |
| `headline-lg` | 32px | 600 | 40px | Section headings |
| `headline-md` | 24px | 600 | 32px | Subsection headings |
| `body-lg` | 18px | 400 | 28px | Lead paragraphs |
| `body-md` | 16px | 400 | 24px | Body text |
| `label-sm` | 12px | 600 | 16px | Labels, captions, uppercase |

Font family: **Hanken Grotesk** (via Google Fonts, loaded in `Head.cshtml`).

Full scale: open `Design.md` and read the `typography:` block.

---

## Spacing tokens

| Token | Value | Usage |
|---|---|---|
| `margin-desktop` | 64px | Side margins on desktop |
| `margin-mobile` | 20px | Side margins on mobile |
| `gutter` | 24px | Gap between grid items |
| `section-gap` | 80px | Vertical gap between sections |
| `container-max` | 1280px | Max content width |

---

## How tokens map to CSS

In `arity.tokens.css`:

```css
:root {
  --arity-primary: #000000;
  --arity-on-primary: #ffffff;
  --arity-secondary: #b7102a;
  --arity-surface: #f9f9fb;
  --arity-on-surface: #1a1c1d;
  --arity-outline: #7e75776;
  --arity-error: #ba1a1a;
  --arity-signal-red: #E63946;  /* legacy alias, prefer --arity-secondary */
}
```

In module files:

```css
/* Correct */
.arity-button {
  background-color: var(--arity-primary);
  color: var(--arity-on-primary);
}

/* Incorrect — hardcoded hex */
.arity-button {
  background-color: #000000;
  color: #ffffff;
}
```

**Rule:** Module files reference `--arity-*` tokens. No hardcoded hex unless overriding a DefaultClean rule.

---

## The drift problem

`Design.md` (150 lines, full ramp) and `arity.tokens.css` (18 lines, 8 colors) have drifted apart.

**Plan:** Expand `arity.tokens.css` to expose the full ramp as `--arity-*` custom properties. Do this in a single PR with CSS only. It must make **zero visual change**. New tokens must not be referenced until a later PR uses them.

After the expansion: module files reference tokens. No color appears twice under two names.

See [viewport-plan.md](viewport-plan.md) Section 5 for the full token expansion plan.

---

## Related documents

- [theme-guide.md](theme-guide.md) — How the modular CSS system works
- [viewport-plan.md](viewport-plan.md) — Token source of truth decision
- [theme-playbook.md](theme-playbook.md) — How to add a new CSS file

---

*Last updated: 2026-08-02*
