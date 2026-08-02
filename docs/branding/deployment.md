# Arity nopCommerce Deployment

This document covers Arity-specific deployment configuration.

## Container Registry

Images are pushed to our private registry.

```
registry.arity.co.za/nopcommerce
```

## GitHub Actions Workflow

**File:** `.github/workflows/docker-build.yml`

The workflow builds and pushes Docker images on every push to `develop` or `main`.

### Image Tags

| Trigger | Tags Created |
|---------|-------------|
| Push to `develop` or `main` | `latest`, `\u003cshort-sha\u003e` |
| Manual workflow dispatch | `latest`, `\u003ccustom-tag-or-short-sha\u003e` |

### Manual Build

To trigger a manual build with a custom tag:

1. Go to **Actions** → **Build and Push nopCommerce**.
2. Click **Run workflow**.
3. Optionally enter a custom `image_tag`.
4. Click **Run workflow**.

## Dockerfile Changes

Our `Dockerfile` includes a fix for the `wwwroot/images/3d` directory:

```dockerfile
RUN mkdir -p logs bin wwwroot/images/3d
```

This prevents runtime errors. The application accesses this path at runtime.

## Running Locally

Use the provided `docker-compose.yml`:

```bash
docker-compose up --build
```

This starts two containers:

- `nopcommerce` web container (exposed on port 80)
- `nopcommerce_mssql_server` database container

## Deployment History

| Date | Change |
|------|--------|
| 2025-06-13 | Added GitHub Actions workflow to build and push Docker images |
| 2025-06-13 | Fixed Docker image tag inputs and removed redundant login step |
| 2025-06-13 | Added missing `wwwroot/images/3d` directory to Dockerfile |
| 2025-06-13 | Successfully deployed to `registry.arity.co.za/nopcommerce` |
