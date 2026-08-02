# Arity Documentation Audit — STE Compliance & Housekeeping

> **Date:** 2026-08-01
> **Scope:** All `.md` files in `infrastructure/` and `nopcommerce-src/`
> **Tool:** ASD-STE100 Simplified Technical English linter (`ste_lint.py`)
> **Mode:** Pragmatic (structural rules applied; domain vocabulary retained)

---

## Executive Summary

| Metric | Value |
|---|---|
| Files checked | 22 |
| Total words | 21,664 |
| Total violations | 356 |
| **Overall STE rate** | **1.64 violations per 100 words** |
| Worst offender | `fork-workflow.md` (2.76 violations/100w) |
| Best offender | `ELECTRONICS-SHOP-PLAN.md` (0.68 violations/100w) |

**Assessment:** Most docs are in reasonable shape for pragmatic STE. The worst issues are long sentences (some >200 words), contractions, and banned modals. No document is unreadable, but the top 5 files need a rewrite pass.

**Housekeeping:** 6 duplicate files in `nopcommerce-src/` that now live in `docs/branding/`. 4 electronics shop docs are outdated. Recommended cleanup below.

---

## STE Results — Ranked by Violation Rate

| Rank | File | Type | Words | Violations | Rate/100w | Longest Sentence | Key Issues |
|---|---|---|---|---|---|---|---|
| 🔴 1 | `docs/fork-workflow.md` | procedural | 145 | 4 | **2.76** | 45 | Sentence over limit (2), contraction (1), banned modal (1) |
| 🔴 2 | `README.md` | descriptive | 2,400 | 62 | **2.58** | 183 | Sentence over limit (24), contraction (18), trailing condition (10), synonym rotation (5) |
| 🔴 3 | `nc-src/ELECTRONICS-DOCKER-SETUP.md` | procedural | 1,016 | 27 | **2.66** | 145 | Sentence over limit (15), banned modal (5) |
| 🟡 4 | `docs/branding/deployment.md` | procedural | 190 | 4 | **2.11** | 62 | Sentence over limit (3), trailing condition (1) |
| 🟡 5 | `nc-src/ARITY-DEPLOYMENT.md` | procedural | 190 | 4 | **2.11** | 62 | Same as above — duplicate |
| 🟡 6 | `docs/branding/viewport-plan.md` | descriptive | 956 | 18 | **1.88** | 60 | Sentence over limit (8), semicolon (3), trailing condition (4) |
| 🟡 7 | `nc-src/ARITY-VIEWPORT-PLAN.md` | descriptive | 956 | 18 | **1.88** | 60 | Identical to above |
| 🟡 8 | `nc-src/ELECTRONICS-SHOP-ZIM-SA.md` | descriptive | 1,866 | 35 | **1.88** | 302 | Sentence over limit (12), semicolon (11), banned modal (3) |
| 🟡 9 | `docs/branding/theme-playbook.md` | procedural | 1,150 | 20 | **1.74** | 290 | Sentence over limit (9), semicolon (4) |
| 🟡 10 | `nc-src/ARITY-THEME-PLAYBOOK.md` | procedural | 1,150 | 20 | **1.74** | 290 | Near-duplicate of above |
| 🟡 11 | `nc-src/ARITY-THEME-GAPS.md` | descriptive | 1,333 | 23 | **1.73** | 281 | Sentence over limit (10), trailing condition (4) |
| 🟡 12 | `docs/branding/ui-gaps.md` | descriptive | 1,334 | 23 | **1.72** | 281 | Same content as above |
| 🟡 13 | `nc-src/ARITY-THEME-PLAN.md` | descriptive | 1,271 | 21 | **1.65** | 114 | Sentence over limit (10), trailing condition (4) |
| 🟢 14 | `nc-src/ARITY-SKILLS.md` | descriptive | 852 | 12 | **1.41** | 213 | Sentence over limit (8), contraction (1) |
| 🟢 15 | `docs/branding/README.md` | descriptive | 316 | 4 | **1.27** | 160 | Sentence over limit (2), trailing condition (1), synonym rotation (1) |
| 🟢 16 | `nc-src/ARITY-MODEL-TEAM.md` | descriptive | 1,223 | 15 | **1.23** | 1,043 | Sentence over limit (6), contraction (2), banned modal (1) |
| 🟢 17 | `docs/branding/theme-guide.md` | procedural | 753 | 9 | **1.20** | 79 | Sentence over limit (5), contraction (2) |
| 🟢 18 | `nc-src/ARITY-THEME-GUIDE.md` | procedural | 753 | 9 | **1.20** | 79 | Near-duplicate of above |
| 🟢 19 | `docs/branding/backup-restore.md` | procedural | 174 | 2 | **1.15** | 22 | Sentence over limit (2) |
| 🟢 20 | `nc-src/ARITY-BACKUP-RESTORE.md` | procedural | 174 | 2 | **1.15** | 22 | Near-duplicate of above |
| ✅ 21 | `nc-src/ELECTRONICS-SHOP-MINIMAL.md` | descriptive | 1,109 | 8 | **0.72** | 447 | Sentence over limit (4), banned modal (1) |
| ✅ 22 | `nc-src/ELECTRONICS-SHOP-PLAN.md` | descriptive | 2,353 | 16 | **0.68** | 924 | Sentence over limit (8) |

**Legend:** 🔴 Needs rewrite | 🟡 Needs minor fixes | 🟢 Acceptable | ✅ Good

---

## Duplicate & Outdated File Analysis

### Duplicates in `nopcommerce-src/` (superseded by `docs/branding/`)

| In `nopcommerce-src/` | In `docs/branding/` | Status | Action |
|---|---|---|---|
| `ARITY-VIEWPORT-PLAN.md` | `viewport-plan.md` | **IDENTICAL** | ✅ Safe to delete |
| `ARITY-BACKUP-RESTORE.md` | `backup-restore.md` | Near-duplicate (97 vs 104 lines) | Review diff, then delete |
| `ARITY-DEPLOYMENT.md` | `deployment.md` | Near-duplicate (67 vs 69 lines) | Review diff, then delete |
| `ARITY-THEME-GUIDE.md` | `theme-guide.md` | Near-duplicate (176 vs 189 lines) | Review diff, then delete |
| `ARITY-THEME-PLAYBOOK.md` | `theme-playbook.md` | Near-duplicate (540 vs 564 lines) | Review diff, then delete |
| `ARITY-THEME-GAPS.md` | `ui-gaps.md` | Near-duplicate (132 vs 135 lines) | Review diff, then delete |

**Note:** The `docs/branding/` copies are the newer versions (copied and auto-formatted during the centralization PR). The `nopcommerce-src/` originals are now stale.

### Outdated Electronics Shop Docs

These were written during early exploration (22 days old) and are now superseded by Arity renewable energy work:

| File | Words | STE Rate | Recommendation |
|---|---|---|---|
| `ELECTRONICS-DOCKER-SETUP.md` | 1,016 | 2.66 | **Archive or delete.** Replaced by `docs/branding/deployment.md` |
| `ELECTRONICS-SHOP-MINIMAL.md` | 1,109 | 0.72 | **Archive.** Superseded by Arity work |
| `ELECTRONICS-SHOP-PLAN.md` | 2,353 | 0.68 | **Archive.** Superseded by Arity work |
| `ELECTRONICS-SHOP-ZIM-SA.md` | 1,866 | 1.88 | **Archive.** Superseded by Arity work |

### Remaining Active Docs in `nopcommerce-src/`

These have no equivalent in `docs/branding/` and should stay:

| File | Words | STE Rate | Recommendation |
|---|---|---|---|
| `ARITY-MODEL-TEAM.md` | 1,223 | 1.23 | Keep. Model team docs. One sentence is 1,043 words (probably JSON or table) — investigate. |
| `ARITY-SKILLS.md` | 852 | 1.41 | Keep. Skill documentation. Minor fixes needed. |

---

## Most Common Violation Types (Across All Files)

| Violation Type | Count | % of Total | Fix Strategy |
|---|---|---|---|
| **Sentence over limit** | 138 | 39% | Split long sentences. Target: ≤20 words (procedural), ≤25 words (descriptive) |
| **Contraction** | 27 | 8% | Replace `'ll`, `'re`, `'s`, `'ve`, `'d` with full forms |
| **Trailing condition** | 29 | 8% | Move `if` clauses to the START of the sentence |
| **Banned modal** | 17 | 5% | Replace `should`/`could`/`may` with `must`/`can` |
| **Semicolon** | 18 | 5% | Split into two sentences |
| **Synonym rotation** | 13 | 4% | Pick ONE word per concept and use it consistently |
| **Perfect tense** | 2 | <1% | Rewrite in simple past/present |
| **Latin abbreviation** | 3 | <1% | Replace `e.g.` → `for example`, `i.e.` → `that is` |
| **Slop word** | 0 | 0% | None detected |

---

## Recommended Cleanup Actions

### Phase 1 — Delete Stale Files (5 min)

```bash
cd /Users/murungu/Developer/infrastructure/nopcommerce-src
# Remove exact duplicate
git rm ARITY-VIEWPORT-PLAN.md

# Archive electronics shop docs to an archive/ folder or delete
mkdir -p archive/electronics
git mv ELECTRONICS-DOCKER-SETUP.md archive/electronics/
git mv ELECTRONICS-SHOP-MINIMAL.md archive/electronics/
git mv ELECTRONICS-SHOP-PLAN.md archive/electronics/
git mv ELECTRONICS-SHOP-ZIM-SA.md archive/electronics/
```

### Phase 2 — Review Near-Duplicates (15 min)

For the 5 near-duplicate pairs, run a diff to check if `docs/branding/` has newer content:

```bash
diff nopcommerce-src/ARITY-BACKUP-RESTORE.md docs/branding/backup-restore.md
diff nopcommerce-src/ARITY-DEPLOYMENT.md docs/branding/deployment.md
diff nopcommerce-src/ARITY-THEME-GUIDE.md docs/branding/theme-guide.md
diff nopcommerce-src/ARITY-THEME-PLAYBOOK.md docs/branding/theme-playbook.md
diff nopcommerce-src/ARITY-THEME-GAPS.md docs/branding/ui-gaps.md
```

If `docs/branding/` is newer (it should be — auto-formatted during PR), delete the `nopcommerce-src/` copy.

### Phase 3 — STE Rewrite Priority (2-3 hours total)

**Priority order:**

1. **`docs/fork-workflow.md`** (145 words, 4 fixes) — Quick win
2. **`docs/branding/deployment.md`** (190 words, 4 fixes) — Quick win
3. **`docs/branding/theme-playbook.md`** (1,150 words, 20 fixes) — Long sentences and semicolons
4. **`docs/branding/viewport-plan.md`** (956 words, 18 fixes) — Semicolons and trailing conditions
5. **`README.md`** (2,400 words, 62 fixes) — Biggest file, but lowest impact (it's a general repo README, not user-facing)

**Skip:** Electronics shop docs (will be archived/deleted anyway).

---

## Appendix: STE Fix Cheat Sheet

| Violation | Example (Wrong) | Example (Right) |
|---|---|---|
| **Sentence too long** | "If you want to configure the theme you must first make sure that the CSS files are in the correct location and then you must restart the application." | "Make sure that the CSS files are in the correct location. Then restart the application." |
| **Contraction** | "You'll want to..." | "You will want to..." |
| **Banned modal** | "You should check..." | "You must check..." (requirement) or "Check..." (imperative) |
| **Trailing condition** | "Increase the timeout if the network is slow." | "If the network is slow, increase the timeout." |
| **Semicolon** | "Run the build; then check the output." | "Run the build. Then check the output." |
| **Latin abbrev.** | "Use e.g. Redis or MongoDB." | "Use Redis, MongoDB, or a similar database." |
| **Synonym rotation** | "Check the config; verify the settings." | "Make sure that the configuration is correct." |

---

*Generated by `ste_lint.py` (ASD-STE100 Issue 9, pragmatic mode).*
*No tool guarantees full compliance — final approval rests with the writer.*
