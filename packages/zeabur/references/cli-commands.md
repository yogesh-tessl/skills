# Zeabur CLI Complete Command Reference

All commands: `npx zeabur <command>`. Global flag `-i=false` disables interactive prompts.

## Table of Contents

- [Auth](#auth)
- [Context](#context)
- [Project](#project)
- [Service](#service)
- [Deployment](#deployment)
- [Domain](#domain)
- [Variable](#variable)
- [Template](#template)
- [Quick Actions](#quick-actions)
- [Profile & Misc](#profile--misc)

## Auth

```bash
npx zeabur auth login              # Browser-based login
npx zeabur auth login --token <T>  # Token login (CI/CD)
npx zeabur auth logout
npx zeabur auth status             # Check login state
```

## Context

Set working context to avoid repeating project/service/env flags:

```bash
npx zeabur context set project [--name <name>|--id <id>]
npx zeabur context set service [--name <name>|--id <id>]
npx zeabur context set env --id <env-id>
npx zeabur context get             # Show current context
npx zeabur context clear
```

## Project

```bash
npx zeabur project ls              # List all projects
npx zeabur project get             # Get project details (uses context)
npx zeabur project create          # Create new project (interactive region selection)
npx zeabur project delete          # Delete project
npx zeabur project export          # Export project config
```

## Service

```bash
npx zeabur service ls              # List services in context project
npx zeabur service get             # Get service details
npx zeabur service deploy          # Deploy service
npx zeabur service delete          # Delete service
npx zeabur service restart         # Restart service
npx zeabur service redeploy        # Rebuild and redeploy
npx zeabur service suspend         # Suspend (stop billing)
npx zeabur service exec            # Shell into container
npx zeabur service expose          # Expose service port
npx zeabur service instruction     # Connection instructions
npx zeabur service metric          # Resource usage metrics
npx zeabur service network         # Network config
npx zeabur service update tag      # Update Docker image tag
```

## Deployment

```bash
npx zeabur deployment get          # Latest deployment info
npx zeabur deployment list         # All deployments
npx zeabur deployment log -t=build    # Build logs
npx zeabur deployment log -t=runtime  # Runtime logs
```

## Domain

```bash
npx zeabur domain list             # List bound domains
npx zeabur domain create           # Bind domain (interactive)
npx zeabur domain delete           # Unbind domain
```

## Variable

```bash
npx zeabur variable list           # List env vars
npx zeabur variable create --key <K> --value <V>
npx zeabur variable update --key <K> --value <V>
npx zeabur variable delete --key <K>
npx zeabur variable env            # Export as .env format
```

## Template

```bash
npx zeabur template list           # List templates
npx zeabur template get            # Get template details
npx zeabur template search         # Search marketplace
npx zeabur template deploy -f template.yaml   # Deploy from YAML
npx zeabur template create -f template.yaml   # Publish template
npx zeabur template update -c CODE -f template.yaml  # Update template
npx zeabur template delete
```

## Quick Actions

```bash
npx zeabur deploy                  # Interactive deploy from current dir
npx zeabur upload                  # Upload local project files
```

## Profile & Misc

```bash
npx zeabur profile get             # Account info
npx zeabur version                 # CLI version
npx zeabur completion              # Shell autocomplete setup
```

## Common Flag Patterns

```bash
# Specify resources without context
--name <project-name>
--id <project-id>
--service-name <name>
--service-id <id>
--env-id <environment-id>

# Non-interactive (CI/CD)
-i=false
```

## Known CLI Interactive Limitations

The following commands **force interactive project/service selection** even when `--id` or `-i=false` is provided. In non-interactive environments (Claude Code, CI/CD), fall back to GraphQL API:

| Command | Issue | API Fallback |
|---------|-------|-------------|
| `project delete --id <id>` | Forces interactive selection | `mutation { deleteProject(_id: "xxx") }` |
| `service ls` (without working context) | Forces interactive project selection | `query { project(_id: "xxx") { services { ... } } }` |
| `context set project --id <id>` | May fail with EOF in non-interactive | Use API to get project info, then set context by `--name` |

**Reliable non-interactive commands**: `project ls`, `auth status`, `auth login --token`, `service restart` (with context set), `deployment log`.

## CI/CD Example

```bash
# In CI pipeline
npx zeabur auth login --token $ZEABUR_TOKEN
npx zeabur context set project --name my-project
npx zeabur context set service --name my-api
npx zeabur service redeploy -i=false
```
