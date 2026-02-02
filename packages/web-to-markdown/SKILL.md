---
name: web-to-markdown
description: Convert web pages to Markdown format using Jina AI's reader service. Use when the user asks to convert, generate, create, transform, or download a web page, website, or URL into Markdown, MD, or md format. Handles various phrasings like "convert this page to markdown", "generate markdown from this website", "create md file from this URL".
---

# Web to Markdown Converter

Convert any web page to clean Markdown format using Jina AI's reader service.

## Process

When a user requests to convert a web page to Markdown:

1. **Extract the URL** from the user's request
2. **Construct Jina URL**: Prepend `https://r.jina.ai/` before the user's URL
3. **Fetch with curl**: Use `curl` to retrieve the Markdown content
4. **Save to file**: Write the content to `/mnt/user-data/outputs/{filename}.md`
5. **Provide download link**: Give the user a link to the generated file

## Command Template

```bash
curl -s "https://r.jina.ai/{USER_URL}" > /mnt/user-data/outputs/{filename}.md
```

## Example Workflow

User request: "Convert https://example.com/article into markdown"

Execute:
```bash
curl -s "https://r.jina.ai/https://example.com/article" > /mnt/user-data/outputs/article.md
```

Then provide link: `computer:///mnt/user-data/outputs/article.md`

## Filename Generation

Generate a sensible filename from the URL:
- Use the last path segment if available (e.g., `article` from `/articles/article`)
- Remove any file extensions from the URL
- Sanitize by replacing special characters with underscores or hyphens
- Add `.md` extension
- If user specifies a custom filename, use that instead

## Common User Phrasings

This skill handles various ways users might request conversion:
- "Convert this page to markdown"
- "Generate markdown from this URL"
- "Create an MD file from this website"
- "Download this webpage as markdown"
- "Turn this page into a markdown file"
