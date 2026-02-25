# Zeabur Common Recipes

## Table of Contents

- [Next.js + PostgreSQL Full Stack](#nextjs--postgresql-full-stack)
- [Monorepo Deployment](#monorepo-deployment)
- [Staging + Production Environments](#staging--production-environments)
- [CI/CD with GitHub Actions](#cicd-with-github-actions)
- [Database Migration on Deploy](#database-migration-on-deploy)
- [Docker Image Deployment](#docker-image-deployment)
- [Recovering Suspended Services (App + DB)](#recovering-suspended-services-app--db)

## Next.js + PostgreSQL Full Stack

### Step 1: Create project and deploy DB

```bash
npx zeabur auth login
npx zeabur project create              # Select region
npx zeabur context set project --name <project-name>
```

Deploy PostgreSQL from marketplace via Dashboard, or use template:

```yaml
apiVersion: zeabur.com/v1
kind: Template
metadata:
  name: nextjs-postgres
spec:
  services:
    - name: db
      template: PREBUILT
      spec:
        source:
          image: postgres:16
        ports:
          - id: pg
            port: 5432
            type: TCP
        volumes:
          - id: pgdata
            dir: /var/lib/postgresql/data
        env:
          POSTGRES_PASSWORD:
            default: "${PASSWORD}"
            expose: true
          POSTGRES_DB:
            default: "app"
            expose: true
```

### Step 2: Deploy Next.js app

```bash
# In Next.js project directory
npx zeabur deploy
```

### Step 3: Connect app to DB

Set env var on the Next.js service:

```bash
npx zeabur context set service --name <nextjs-service>
npx zeabur variable create --key DATABASE_URL \
  --value "postgres://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DATABASE}"
```

### Step 4: Bind domain

```bash
npx zeabur domain create    # Follow prompts for custom or auto domain
```

## Monorepo Deployment

For a monorepo with multiple apps (e.g., `packages/web`, `packages/api`):

### Option A: Root-level zbpack.json per service

Create separate Zeabur services from the same GitHub repo. For each service, set `app_dir` in the **root** `zbpack.json` via environment variable or Dashboard service settings.

Alternatively, set the root directory per service in the Zeabur Dashboard (Service > Settings > Root Directory).

### Option B: Use environment variables

For each service, set these env vars in Zeabur Dashboard:

```
# Web service
ZBPACK_APP_DIR=packages/web
ZBPACK_BUILD_COMMAND=pnpm run build --filter=web
ZBPACK_START_COMMAND=node packages/web/.next/standalone/server.js

# API service
ZBPACK_APP_DIR=packages/api
ZBPACK_BUILD_COMMAND=pnpm run build --filter=api
ZBPACK_START_COMMAND=node packages/api/dist/index.js
```

### Option C: Per-service Dockerfile

Create `web.Dockerfile` and `api.Dockerfile` in the repo root. Set `ZBPACK_DOCKERFILE_NAME` per service.

## Staging + Production Environments

Zeabur supports multiple environments per project.

### Setup via Dashboard

1. Go to project settings
2. Create a new environment (e.g., "staging")
3. Each environment gets its own set of services, domains, and variables

### Per-environment variables

```bash
# Set context to staging environment
npx zeabur context set env --id <staging-env-id>
npx zeabur variable create --key API_URL --value "https://staging-api.example.com"

# Switch to production
npx zeabur context set env --id <prod-env-id>
npx zeabur variable create --key API_URL --value "https://api.example.com"
```

### Per-environment domains

```bash
# Staging
npx zeabur domain create    # staging.example.com

# Production
npx zeabur context set env --id <prod-env-id>
npx zeabur domain create    # example.com
```

## CI/CD with GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to Zeabur
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Zeabur
        run: |
          npx zeabur auth login --token ${{ secrets.ZEABUR_TOKEN }}
          npx zeabur context set project --name my-project
          npx zeabur context set service --name my-service
          npx zeabur service redeploy -i=false
```

**Note**: For GitHub-integrated repos, Zeabur auto-deploys on push. This workflow is for cases where you need custom CI steps before triggering deploy.

## Database Migration on Deploy

Use `pre_start_command` in zbpack.json to run migrations before the app starts:

```json
{
  "build_command": "pnpm run build",
  "start_command": "node server.js",
  "pre_start_command": "npx prisma migrate deploy"
}
```

Common migration commands:
- **Prisma**: `npx prisma migrate deploy`
- **Drizzle**: `npx drizzle-kit push`
- **Django**: `python manage.py migrate`
- **Rails**: `bundle exec rake db:migrate`

## Docker Image Deployment

Deploy a pre-built Docker image from a registry (Docker Hub, GHCR, etc.) without building from source.

### Option A: Via Template YAML

```yaml
apiVersion: zeabur.com/v1
kind: Template
metadata:
  name: my-docker-app
spec:
  services:
    - name: app
      template: PREBUILT
      spec:
        source:
          image: ghcr.io/myorg/myapp:latest
        ports:
          - id: web
            port: 8080
            type: HTTP
        env:
          DATABASE_URL:
            default: "postgres://user:pass@db.zeabur.internal:5432/mydb"
```

Deploy with: `npx zeabur template deploy -f template.yaml`

### Option B: Via Dashboard

1. Go to project > Add Service > Docker Image
2. Enter image reference (e.g., `ghcr.io/myorg/myapp:latest`)
3. Zeabur pulls and runs the image
4. Configure ports, env vars, and domain as needed

### Notes

- For private registries, configure registry credentials in the Dashboard
- The image must expose at least one port for Zeabur to route traffic
- Use specific tags (e.g., `v1.2.3`) instead of `latest` for reproducible deployments
- To update the image version, change the tag and redeploy

## Recovering Suspended Services (App + DB)

When a database service is auto-suspended (e.g., due to budget limits), dependent apps may return 500 errors. Follow this sequence:

### Step 1: Restart the database first

```bash
npx zeabur context set service --name mysql   # or postgres, etc.
npx zeabur service restart
```

Or via API:
```graphql
mutation { restartService(serviceID: "<db-service-id>", environmentID: "<env-id>") }
```

### Step 2: Wait for DB to become RUNNING

Wait 10–15 seconds, then verify:

```bash
npx zeabur service get   # Check status
```

Or via API: query the project services and confirm status is `RUNNING`.

### Step 3: Restart the dependent app

The app likely has stale/broken DB connections. Restart it:

```bash
npx zeabur context set service --name <app-name>
npx zeabur service restart
```

### Step 4: Wait and verify

Wait 15–30 seconds (depending on app startup time), then test:

```bash
curl -s -o /dev/null -w "HTTP %{http_code}" https://<your-domain>/
```

Expect 502 during startup, then 200 when ready. If still 502 after 60 seconds, check runtime logs.
