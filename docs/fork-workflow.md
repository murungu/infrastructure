# nopCommerce Fork Workflow

This guide ensures you can pull upstream updates from `nopSolutions/nopCommerce` without merge conflicts.

## Repositories

| Repo | URL | Purpose |
|------|-----|---------|
| **Your fork (origin)** | `git@github.com:Arity-Solutions/nopCommerce.shop.git` | Where you push your changes |
| **Official (upstream)** | `https://github.com/nopSolutions/nopCommerce.git` | Source of truth for updates |

## Golden Rule

> **Never commit directly to `develop`.** Always work on feature branches.
>
> This keeps `develop` clean and allows fast-forward merges from upstream.

## Daily Workflow

### 1. Start a new feature

```bash
cd nopcommerce-src
git checkout develop
git pull origin develop          # make sure you're current
git checkout -b feature/my-plugin

# ... make changes ...
git add .
git commit -m "feat: add custom payment plugin"
git push origin feature/my-plugin

# Open PR on GitHub to merge into develop
```

### 2. Pull upstream updates (weekly/monthly)

```bash
cd nopcommerce-src
git fetch upstream               # download latest from nopSolutions
git checkout develop
git merge upstream/develop       # fast-forward if you kept develop clean

# If there are conflicts, resolve them, then:
git push origin develop
```

### 3. Rebuild after upstream merge

```bash
cd ..                          # back to infrastructure root
make tag IMAGE_TAG=before-upstream-merge   # safety net
make up                        # rebuilds from updated source
```

### 4. If the build breaks

```bash
make rollback IMAGE_TAG=before-upstream-merge
```

## What Happens If You Committed to `develop`?

If you committed the Dockerfile fix directly to `develop` (like we just did), future `git merge upstream/develop` may create a merge commit instead of fast-forwarding. That's fine — just resolve any conflicts during the merge.

For **all future custom work**, use feature branches:

```bash
git checkout -b feature/custom-theme
git commit -m "feat: add dark mode theme"
git push origin feature/custom-theme
# Open PR → merge to develop
```

## Keeping the Dockerfile Fix Separate

Your `Dockerfile` fix (`mkdir -p wwwroot/images/3d`) is now on `develop` and pushed to origin. If upstream later fixes it too, you'll get a trivial merge conflict. Resolve by accepting upstream's version and deleting yours.

## Cheat Sheet

```bash
# New feature
git checkout develop && git pull origin develop
git checkout -b feature/xxx
# ...edit...
git commit && git push origin feature/xxx

# Upstream update
git fetch upstream
git checkout develop
git merge upstream/develop
git push origin develop

# Rebuild infrastructure
make tag IMAGE_TAG=safe-point
make up
```
