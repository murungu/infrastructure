# nopCommerce Fork Workflow

This guide explains how to add custom work and pull updates from `nopSolutions/nopCommerce`.

## Repositories

| Repository | URL | Purpose |
| --- | --- | --- |
| **Arity fork (`origin`)** | `git@github.com:Arity-Solutions/arity.nopCommerce.shop.git` | Stores Arity changes |
| **Official repository (`upstream`)** | `https://github.com/nopSolutions/nopCommerce.git` | Supplies nopCommerce updates |

## Golden Rule

> **Never commit directly to `main`.** Create a feature branch and open a pull request against `main`.

The official nopCommerce repository uses `develop` for active development. Arity uses `main` as its protected integration branch.

## Daily Workflow

### 1. Start a feature

```bash
cd nopcommerce-src
git switch main
git pull origin main
git switch -c feature/my-plugin
```

Make the change. Then commit and push the feature branch:

```bash
git add .
git commit -m "feat: add custom payment plugin"
git push -u origin HEAD
```

Open a pull request against `main`. Merge after review and approval.

### 2. Pull upstream updates

Create a branch for the upstream merge. Do not merge upstream changes directly into `main`.

```bash
cd nopcommerce-src
git switch main
git pull origin main
git fetch upstream
git switch -c chore/sync-upstream-YYYY-MM-DD
git merge upstream/develop
```

Resolve conflicts on this branch. Then push the branch:

```bash
git push -u origin HEAD
```

Open a pull request against `main`. Merge after the build and review are complete.

### 3. Rebuild after the pull request merges

```bash
cd nopcommerce-src
git switch main
git pull origin main
cd ..
make tag IMAGE_TAG=before-upstream-merge
make up
```

The image tag is a rollback point. The `make up` command rebuilds the application from the updated source.

### 4. Roll back a failed build

```bash
make rollback IMAGE_TAG=before-upstream-merge
```

## If a Commit Reaches `main` Directly

Do not add more commits to `main`. Create the next change on a feature branch. Use pull requests for all later work.

## Historical Dockerfile Fix

The fork contains a `Dockerfile` fix that creates `wwwroot/images/3d`. An upstream change can conflict with this fix.

If a conflict occurs, compare both versions. Keep the upstream version when it provides the same behavior.

## Cheat Sheet

```bash
# New feature
git switch main
git pull origin main
git switch -c feature/xxx
# Edit files.
git commit
git push -u origin HEAD
# Open a pull request against main.

# Upstream update
git switch main
git pull origin main
git fetch upstream
git switch -c chore/sync-upstream-YYYY-MM-DD
git merge upstream/develop
git push -u origin HEAD
# Open a pull request against main.

# Rebuild infrastructure after merge
make tag IMAGE_TAG=safe-point
make up
```
