# nopCommerce Fork Workflow

This guide shows you how to pull upstream updates from `nopSolutions/nopCommerce` without merge conflicts.

## Repositories

| Repo | URL | Purpose |
|------|-----|---------|
| **Your fork (origin)** | `git@github.com:Arity-Solutions/arity.nopCommerce.shop.git` | Where you push your changes |
| **Official (upstream)** | `https://github.com/nopSolutions/nopCommerce.git` | Source of truth for updates |

## Golden Rule

> **Never commit directly to `develop`.** Always work on feature branches.
>
> This keeps `develop` clean. It also allows fast-forward merges from upstream.

## Daily Workflow

### 1. Start a new feature

```bash
cd nopcommerce-src
git checkout develop
git pull origin develop
git checkout -b feature/my-plugin
```

Make your changes. Then commit and push:

```bash
git add .
git commit -m "feat: add custom payment plugin"
git push origin feature/my-plugin
```

Open a PR on GitHub to merge into `develop`.

### 2. Pull upstream updates (weekly or monthly)

```bash
cd nopcommerce-src
git fetch upstream
git checkout develop
git merge upstream/develop
```

If `develop` is clean, this is a fast-forward merge.

If there are conflicts, resolve them. Then push:

```bash
git push origin develop
```

### 3. Rebuild after upstream merge

```bash
cd ..
make tag IMAGE_TAG=before-upstream-merge
make up
```

The `make tag` command creates a safety net. The `make up` command rebuilds from the updated source.

### 4. If the build breaks

```bash
make rollback IMAGE_TAG=before-upstream-merge
```

## What Happens If You Commit to `develop`?

If you commit directly to `develop`, future `git merge upstream/develop` can create a merge commit. This is not a problem. Resolve any conflicts during the merge.

For all future custom work, use feature branches:

```bash
git checkout -b feature/custom-theme
git commit -m "feat: add dark mode theme"
git push origin feature/custom-theme
```

Then open a PR and merge to `develop`.

## Keeping the Dockerfile Fix Separate

The `Dockerfile` fix (`mkdir -p wwwroot/images/3d`) is on `develop` and pushed to origin. If upstream fixes this too, you will get a trivial merge conflict. Resolve the conflict by accepting upstream's version and deleting yours.

## Cheat Sheet

```bash
# New feature
git checkout develop && git pull origin develop
git checkout -b feature/xxx
# ... edit ...
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
