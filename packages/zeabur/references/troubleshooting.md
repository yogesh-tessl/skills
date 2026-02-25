# Zeabur Troubleshooting Guide

## Table of Contents

- [Authentication Issues](#authentication-issues)
- [Build Failures](#build-failures)
- [Service Unreachable](#service-unreachable)
- [Project Management](#project-management)
- [Prebuilt / Marketplace Services](#prebuilt--marketplace-services)
- [Database Issues](#database-issues)
- [Environment Variables](#environment-variables)
- [Domain & SSL](#domain--ssl)
- [Performance & Stability](#performance--stability)

## Authentication Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| `npx zeabur auth status` shows not logged in | Token expired or revoked | Re-run `npx zeabur auth login` or `npx zeabur auth login --token <NEW_TOKEN>` |
| CLI commands return 401/unauthorized | API token expired or invalid | Generate a new token at Dashboard > Settings > API Keys, then re-login |
| `auth login --token` succeeds but commands still fail | Token lacks required permissions | Verify token scope; try generating a new token |
| GraphQL API returns `{"errors":[{"message":"Unauthorized"}]}` | Missing or malformed Authorization header | Ensure header is `Authorization: Bearer <TOKEN>` (no extra spaces or quotes) |
| Browser login flow hangs | Network/firewall blocking callback | Try API token method instead: `npx zeabur auth login --token <TOKEN>` |
| Token works in CLI but not in API | Different auth mechanisms | CLI tokens and API tokens are the same; check for copy-paste errors (trailing newline, quotes) |

**Diagnostic**: `npx zeabur auth status` — if expired, re-authenticate before proceeding.

## Build Failures

| Symptom | Cause | Fix |
|---------|-------|-----|
| Wrong language detected | zbpack misidentified project | Set `plan_type` in `zbpack.json` |
| Dependencies fail | Missing lock file or wrong package manager | Ensure lock file committed; set `install_command` |
| Dockerfile ignored | `ZBPACK_IGNORE_DOCKERFILE=true` set | Remove the env var or set to `false` |
| Out of memory during build | Large project or dependencies | Optimize dependencies; consider multi-stage Dockerfile |
| Monorepo wrong directory | zbpack builds from root | Set `app_dir` in `zbpack.json` |

**Diagnostic**: `npx zeabur deployment log -t=build`

## Service Unreachable

| Symptom | Cause | Fix |
|---------|-------|-----|
| 502/503 errors | App not listening on correct port | Listen on `$PORT` (default 8080) or `0.0.0.0` |
| No domain bound | Service has no public endpoint | `npx zeabur domain create` |
| App crashes on start | Missing env vars or config | Check runtime logs, verify all required vars set |
| Health check fails | App slow to start | Add warmup or adjust start command |

**Diagnostic**: `npx zeabur deployment log -t=runtime`

## Project Management

| Symptom | Cause | Fix |
|---------|-------|-----|
| CLI `project delete` ignores `--id` flag | CLI forces interactive project selection | Use GraphQL API `deleteProject(_id: "xxx")` instead |
| `deleteProject` returns `true` but project still appears in query | API query cache delay; Dashboard reflects real state | Wait a few minutes or verify via Dashboard |
| CLI `context set project --id` not recognized | CLI requires interactive selection for some commands | Use `-i=false` or fall back to GraphQL API with project `_id` |

## Prebuilt / Marketplace Services

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Cannot redeploy in-place" | `redeployService` requires GitHub repo | Use `restartService` instead for prebuilt services |
| Suspended service won't resume | No `resumeService` mutation exists | Use `restartService` to resume suspended services |
| Dependent service 500 after DB resumed | App lost DB connection during suspension | Restart the dependent service after resuming DB |

## Database Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| Connection refused | Using public URL internally | Use private hostname: `[service].zeabur.internal` |
| Connection timeout | Wrong port | Check service's exposed port variables |
| Auth failure | Wrong credentials | Check exposed env vars from DB service |
| Data lost after redeploy | No volume mounted | Mount persistent volume |

**Diagnostic**: `npx zeabur service exec` then test connection from inside container.

## Environment Variables

| Symptom | Cause | Fix |
|---------|-------|-----|
| Var not available | Not set for this environment | Set via CLI or Dashboard for correct environment |
| `${REF}` not resolved | Referenced service not exposing var | Set `expose: true` on source service |
| Changes not effective | Service needs restart | `npx zeabur service restart` |
| Wrong var value | Overridden by higher priority source | Check resolution order: own > exposed > predefined |

## Domain & SSL

| Symptom | Cause | Fix |
|---------|-------|-----|
| SSL error | Cloudflare Full (Strict) mode | Switch to Full (not Strict) |
| Domain not resolving | DNS not configured | Add CNAME record pointing to zeabur |
| Apex domain fails | CNAME not supported for root | Use Cloudflare CNAME flattening or A record |
| Redirect loop | Mixed HTTP/HTTPS config | Ensure app doesn't force redirect; let Zeabur handle SSL |

## Performance & Stability

| Symptom | Cause | Fix |
|---------|-------|-----|
| Slow cold start | Suspended service waking up | Keep service active or optimize startup |
| High memory cost | Over-provisioned | Monitor with `npx zeabur service metric`; optimize app |
| Service restarts | OOM or crash | Check runtime logs; reduce memory usage |
| Zero-downtime fails | Volume mounted | Volumes require full restart; plan maintenance windows |

