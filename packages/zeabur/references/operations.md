# Zeabur Operations Reference

## Table of Contents

- [Cost Optimization](#cost-optimization)
- [High Availability](#high-availability)
- [MCP Integration](#mcp-integration)

## Cost Optimization

Rates (as of 2025, verify at zeabur.com/docs for latest):

| Resource | Rate |
|----------|------|
| vCPU | Free (shared cluster) |
| Memory | ~$10.80/GB/month |
| Egress | $0.10/GB |
| Volume | $0.20/GB/month |

Tips:
- Use private networking (`*.zeabur.internal`) for inter-service communication — no egress cost
- Set project budget (min $10/month) to auto-suspend at limit
- Suspend idle services: `npx zeabur service suspend`
- Monitor usage: `npx zeabur service metric`

## High Availability

Zeabur does not support auto-scaling. Recommended HA patterns:
1. **DNS load balancing** (Cloudflare/Bunny) — distribute across multiple instances
2. **Internal reverse proxy** (recommended) — deploy Caddy/NGINX using `.zeabur.internal` hostnames
3. Avoid external L7 proxy — interferes with firewall and rate limiting

## MCP Integration

Zeabur provides an official MCP server for AI tool integration:

```json
{
  "mcpServers": {
    "zeabur": {
      "command": "npx",
      "args": ["zeabur-mcp@latest"],
      "env": { "ZEABUR_TOKEN": "<your-api-token>" }
    }
  }
}
```

Capabilities: create projects, deploy apps, monitor services, set env vars, bind domains, view logs, execute DB commands — all from Claude Desktop or Cursor.
