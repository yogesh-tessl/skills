# Zeabur Deployment & Configuration Reference

## Table of Contents

- [Template YAML Format](#template-yaml-format)
- [zbpack.json Configuration](#zbpackjson-configuration)
- [Supported Languages](#supported-languages)
- [Environment Variables](#environment-variables)
- [Predefined Variables](#predefined-variables)
- [Complete Multi-Service Example](#complete-multi-service-example)
- [Volume Configuration](#volume-configuration)

## Template YAML Format

Full schema: https://schema.zeabur.app/

```yaml
apiVersion: zeabur.com/v1
kind: Template
metadata:
  name: my-app
spec:
  description: "App description"
  icon: "https://example.com/icon.svg"
  tags: ["web", "api"]
  readme: "Markdown readme content"

  variables:
    - key: SITE_NAME
      type: STRING          # STRING | DOMAIN | PASSWORD | AI_HUB_KEY
      name: "Site Name"
      description: "Your site name"

  services:
    - name: web
      template: PREBUILT     # GIT | PREBUILT | PREBUILT_V2
      spec:
        source:
          image: nginx:latest
        ports:
          - id: web
            port: 80
            type: HTTP       # HTTP | TCP | UDP
        volumes:
          - id: data
            dir: /data
        env:
          MY_VAR:
            default: "value"
            expose: true      # Make available to other services
            readonly: false
        configs:
          - path: /etc/nginx/nginx.conf
            template: |
              server { listen 80; ... }
        instructions:
          - type: TEXT
            title: "Usage"
            content: "Visit your domain to see the app"
      domainKey: SITE_DOMAIN   # Links to a DOMAIN variable
      dependencies:
        - db                    # Depends on another service

    - name: db
      template: PREBUILT
      spec:
        source:
          image: postgres:16
        ports:
          - id: database
            port: 5432
            type: TCP
        volumes:
          - id: pgdata
            dir: /var/lib/postgresql/data
        env:
          POSTGRES_PASSWORD:
            default: "${PASSWORD}"
            expose: true
```

### GIT Type (deploy from GitHub)

```yaml
- name: api
  template: GIT
  spec:
    source:
      repoURL: "https://github.com/user/api"
      branchName: main
    ports:
      - id: http
        port: 8080
        type: HTTP
    env:
      NODE_ENV:
        default: "production"
```

Key differences from PREBUILT: `template: GIT`, `source` uses `repoURL`/`branchName` instead of `image`. Zeabur auto-detects language and builds from source using zbpack.

### Deploy Template

```bash
# Via CLI
npx zeabur template deploy -f template.yaml

# Via API
mutation {
  deployTemplate(rawSpecYaml: "...", projectID: "xxx") { success }
}
```

## zbpack.json Configuration

Place in project root to control build behavior:

```json
{
  "app_dir": "packages/web",
  "build_command": "pnpm run build",
  "start_command": "node server.js",
  "install_command": "pnpm install",
  "pre_start_command": "npx prisma migrate deploy",
  "output_dir": "dist",
  "plan_type": "nodejs",
  "ignore_dockerfile": true
}
```

### Language-Specific Fields

| Language | Fields |
|----------|--------|
| Node.js/Bun | `framework` |
| Python | `entry`, `version`, `package_manager` |
| Go | `entry`, `cgo` (bool) |
| Rust | `entry`, `app_dir`, `assets` |
| PHP | `version`, `optimize` |
| Dockerfile | `name`, `path` |

### Override via Environment Variables

| Variable | Effect |
|----------|--------|
| `ZBPACK_IGNORE_DOCKERFILE` | `true` to skip Dockerfile |
| `ZBPACK_DOCKERFILE_NAME` | Custom Dockerfile name |

## Supported Languages

zbpack auto-detects: Node.js, Bun, Python, Go, Java, PHP, Ruby, Rust, .NET, Elixir, Dart, Swift, Deno, static sites (Hugo, Zola, MkDocs).

Frameworks: Next.js, Nuxt, Vite, Astro, Remix, Hono, Flask, Django, FastAPI, and more.

## Environment Variables

### Variable Reference Syntax

Use `${VAR_NAME}` to reference other variables:

```
DATABASE_URL=postgres://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DATABASE}
```

### Resolution Priority

1. Current service's own variables
2. Variables exposed by other services in the same project
3. System predefined variables

## Predefined Variables

| Variable | Description |
|----------|-------------|
| `${ZEABUR_WEB_URL}` | Full URL with https |
| `${ZEABUR_WEB_DOMAIN}` | Domain name only |
| `${CONTAINER_HOSTNAME}` | Internal hostname |
| `${PORT}` | Default 8080 for Git services |
| `${PASSWORD}` | Auto-generated random password |
| `${ZEABUR_SERVICE_ID}` | Service ID |
| `${ZEABUR_PROJECT_ID}` | Project ID |
| `${ZEABUR_ENVIRONMENT_ID}` | Environment ID |
| `${ZEABUR_USER_ID}` | Project creator's user ID |
| `${ZEABUR_GIT_COMMIT_SHA}` | Git commit SHA (build only) |
| `${ZEABUR_GIT_BRANCH}` | Git branch (build only) |
| `${ZEABUR_GIT_REPO_NAME}` | Git repo name (build only) |
| `${ZEABUR_GIT_COMMIT_MESSAGE}` | Commit message (build only) |

## Complete Multi-Service Example

Full template for a web app + API + Redis + PostgreSQL:

```yaml
apiVersion: zeabur.com/v1
kind: Template
metadata:
  name: full-stack-app
spec:
  description: "Full stack app with web, API, Redis, and PostgreSQL"
  tags: ["web", "api", "fullstack"]
  variables:
    - key: DOMAIN
      type: DOMAIN
      name: "Domain"
      description: "Your app domain"
  services:
    - name: web
      template: GIT
      spec:
        source:
          repoURL: "https://github.com/user/web"
          branchName: main
        ports:
          - id: http
            port: 3000
            type: HTTP
        env:
          API_URL:
            default: "http://api.zeabur.internal:8080"
      domainKey: DOMAIN
      dependencies: [api]

    - name: api
      template: GIT
      spec:
        source:
          repoURL: "https://github.com/user/api"
          branchName: main
        ports:
          - id: http
            port: 8080
            type: HTTP
        env:
          DATABASE_URL:
            default: "postgres://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@db.zeabur.internal:5432/app"
          REDIS_URL:
            default: "redis://redis.zeabur.internal:6379"
      dependencies: [db, redis]

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

    - name: redis
      template: PREBUILT
      spec:
        source:
          image: redis:7
        ports:
          - id: redis
            port: 6379
            type: TCP
```

Deploy: `npx zeabur template deploy -f template.yaml`

## Volume Configuration

- Mount via Dashboard: Service > Volumes tab
- Specify volume ID and mount path
- **Caution**: Mounting clears existing data at that path
- **Caution**: Volumes disable zero-downtime restart
- Cost: $0.20/GB/month
