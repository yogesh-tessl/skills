# Zeabur API Reference

## Table of Contents

- [GraphQL API](#graphql-api)
- [Authentication](#authentication)
- [Common Queries](#common-queries)
- [Common Mutations](#common-mutations)
- [Subscriptions (Real-time)](#subscriptions)
- [REST Upload API](#rest-upload-api)
- [File Operations](#file-operations)
- [WebSocket Terminal](#websocket-terminal)

## GraphQL API

- **Endpoint**: `https://api.zeabur.com/graphql`
- **Method**: POST
- **Schema Explorer**: [Apollo Explorer](https://studio.apollographql.com/public/zeabur/variant/main/explorer)

## Authentication

Generate API key at Dashboard > Settings > API Keys.

```bash
curl -X POST https://api.zeabur.com/graphql \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"query":"query { me { username } }"}'
```

## Common Queries

```graphql
# Get current user
query { me { username _id } }

# List projects (paginated — note edges/node pattern)
query {
  projects {
    edges {
      node { _id name description createdAt
        environments { _id name }
        services { _id name template status }
      }
    }
  }
}

# Get project with services and status
query {
  project(_id: "xxx") {
    name
    services { _id name template status domains { domain } }
    environments { _id name }
  }
}

# Get deployments
query { deployments(projectID: "xxx", serviceID: "yyy") { _id status createdAt } }

# Get build logs
query { buildLogs(projectID: "xxx", deploymentID: "yyy") { logs } }

# Get runtime logs
query { runtimeLogs(projectID: "xxx", serviceID: "yyy", environmentID: "zzz") { logs } }
```

### Service Status Values

`RUNNING` | `SUSPENDED` | `DEPLOYING` | `ERROR` | `STOPPED`

## Common Mutations

```graphql
# Restart service (also resumes suspended services)
mutation { restartService(serviceID: "xxx", environmentID: "yyy") }

# Redeploy service (requires GitHub repo binding — does NOT work for prebuilt services)
mutation { redeployService(serviceID: "xxx", environmentID: "yyy") }

# Delete project
mutation { deleteProject(_id: "xxx") }

# Add domain
mutation { addDomain(serviceID: "xxx", environmentID: "yyy", domain: "app.example.com") { domain } }

# Set environment variable
mutation { updateEnvironmentVariable(serviceID: "xxx", environmentID: "yyy", key: "MY_VAR", value: "hello") { key value } }
```

### Known Gotchas

- **No `resumeService` mutation** — use `restartService` to resume suspended services
- **`redeployService` fails for prebuilt services** — returns "Cannot redeploy in-place" error. Prebuilt services (databases, marketplace apps) can only be restarted, not redeployed
- **Mutation return types vary** — some return boolean (`restartService`), others return objects. Check Apollo Explorer for exact return types

**Note**: The GraphQL schema evolves. Use [Apollo Explorer](https://studio.apollographql.com/public/zeabur/variant/main/explorer) for the latest available queries and mutations with full type information.

## Subscriptions

Real-time log streaming via GraphQL subscriptions:

```graphql
subscription {
  buildLogReceived(deploymentID: "xxx") {
    message
    timestamp
  }
}

subscription {
  runtimeLogReceived(serviceID: "xxx", environmentID: "yyy") {
    message
    timestamp
  }
}
```

## REST Upload API

### Step 1: Create Upload Session

```bash
POST https://api.zeabur.com/v2/upload
Content-Type: application/json
Authorization: Bearer {TOKEN}

{
  "content_hash": "<SHA256>",
  "content_hash_algorithm": "sha256",
  "content_length": 12345
}
```

Response: `{ "upload_id": "...", "presign_url": "..." }`

### Step 2: Upload to Presigned URL

```bash
PUT {presign_url}
Content-Type: application/octet-stream

<binary data>
```

### Step 3: Prepare for Deployment

```bash
POST https://api.zeabur.com/v2/upload/{upload_id}/prepare
Content-Type: application/json
Authorization: Bearer {TOKEN}

# New project:
{ "upload_type": "new_project" }

# Existing service:
{
  "upload_type": "existing_service",
  "service_id": "xxx",
  "environment_id": "yyy"
}
```

## File Operations

```bash
# Upload file to container (max 100MB)
POST /projects/{pid}/services/{sid}/files
Authorization: Bearer {TOKEN}
Content-Type: multipart/form-data

# Download file from container
GET /projects/{pid}/services/{sid}/files?path=/app/data.json
Authorization: Bearer {TOKEN}
```

## WebSocket Terminal

Connect to container terminal:

```
wss://api.zeabur.com/exec/{service-id}
```

Requires Bearer token authentication in connection headers.
