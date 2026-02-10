# VS Code Extension Security Guide

## Why Security Matters

VS Code extensions run with full system privileges. An XSS vulnerability in a webview can lead to complete system compromise: arbitrary file access, shell command execution, and credential theft.

## Content Security Policy (CSP)

### Mandatory CSP Template

Every webview MUST include this CSP meta tag:

```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'none';
  style-src ${webview.cspSource} 'unsafe-inline';
  script-src 'nonce-${nonce}';
  img-src ${webview.cspSource} https: data:;
  font-src ${webview.cspSource};
  connect-src ${webview.cspSource} https:;
">
```

### CSP Directive Reference

| Directive | Recommended Value | Purpose |
|-----------|------------------|---------|
| `default-src` | `'none'` | Block everything by default |
| `script-src` | `'nonce-${nonce}'` | Only allow scripts with matching nonce |
| `style-src` | `${webview.cspSource}` | Allow extension styles |
| `img-src` | `${webview.cspSource} https:` | Allow extension and HTTPS images |
| `font-src` | `${webview.cspSource}` | Allow extension fonts |
| `connect-src` | `${webview.cspSource}` | Control fetch/XHR requests |

### Nonce Generation

```typescript
function getNonce(): string {
  const array = new Uint8Array(16);
  crypto.getRandomValues(array);
  return Array.from(array, byte => byte.toString(16).padStart(2, '0')).join('');
}
```

### Applying Nonces

```html
<!-- All scripts must have the nonce attribute -->
<script nonce="${nonce}">
  // Inline script (avoid if possible)
</script>

<script nonce="${nonce}" src="${scriptUri}"></script>
```

## Local Resource Restrictions

### Principle of Least Privilege

Restrict `localResourceRoots` to only directories your webview needs:

```typescript
// GOOD: Restricted to specific directory
const panel = vscode.window.createWebviewPanel('myView', 'Title', column, {
  localResourceRoots: [
    vscode.Uri.joinPath(context.extensionUri, 'media'),
    vscode.Uri.joinPath(context.extensionUri, 'dist')
  ]
});

// BAD: Allows access to entire extension
const panel = vscode.window.createWebviewPanel('myView', 'Title', column, {
  localResourceRoots: [context.extensionUri]
});

// WORSE: Allows access to user's workspace
const panel = vscode.window.createWebviewPanel('myView', 'Title', column, {
  localResourceRoots: [vscode.workspace.workspaceFolders?.[0].uri]
});
```

### Converting Local URIs

Always use `asWebviewUri` for local resources:

```typescript
// CORRECT
const styleUri = webview.asWebviewUri(
  vscode.Uri.joinPath(context.extensionUri, 'media', 'style.css')
);

// WRONG - file:// URIs won't work
const styleUri = vscode.Uri.joinPath(context.extensionUri, 'media', 'style.css');
```

## Message Passing Security

### Extension Side Validation

```typescript
panel.webview.onDidReceiveMessage(message => {
  // 1. Validate message is an object
  if (typeof message !== 'object' || message === null) {
    console.error('Invalid message format');
    return;
  }

  // 2. Validate required fields
  if (typeof message.type !== 'string') {
    console.error('Missing message type');
    return;
  }

  // 3. Validate against allowed types (whitelist)
  const allowedTypes = ['getData', 'saveData', 'refresh'];
  if (!allowedTypes.includes(message.type)) {
    console.error('Unknown message type:', message.type);
    return;
  }

  // 4. Type-specific validation
  switch (message.type) {
    case 'saveData':
      if (!isValidData(message.payload)) {
        console.error('Invalid payload');
        return;
      }
      // Process validated message
      break;
  }
});
```

### Webview Side Validation

```javascript
window.addEventListener('message', event => {
  const message = event.data;

  // Validate structure
  if (!message || typeof message.type !== 'string') return;

  // Validate origin (VS Code sets this)
  // Note: event.origin is 'vscode-webview://' in webviews

  switch (message.type) {
    case 'update':
      // Sanitize any HTML content before inserting
      const safeContent = DOMPurify.sanitize(message.content);
      element.innerHTML = safeContent;
      break;
  }
});
```

## Preventing Common Vulnerabilities

### XSS Prevention

```typescript
// NEVER do this
element.innerHTML = userProvidedContent;

// Use textContent for text
element.textContent = userProvidedContent;

// Or sanitize HTML
import DOMPurify from 'dompurify';
element.innerHTML = DOMPurify.sanitize(userProvidedContent);

// Or use template literals with proper escaping
function escapeHtml(text: string): string {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
```

### Command Injection Prevention

```typescript
// NEVER construct shell commands from user input
// BAD
const cmd = `git commit -m "${userMessage}"`;
exec(cmd);

// GOOD - use spawn with array arguments
spawn('git', ['commit', '-m', userMessage]);

// Or validate/sanitize input
function sanitizeCommitMessage(msg: string): string {
  return msg.replace(/[`$\\]/g, '');
}
```

### Path Traversal Prevention

```typescript
// NEVER use user input directly in paths
// BAD
const filePath = path.join(workspaceRoot, userInput);

// GOOD - validate the result is within bounds
function safeJoin(base: string, ...paths: string[]): string | null {
  const result = path.resolve(base, ...paths);
  if (!result.startsWith(base)) {
    return null; // Path traversal attempt
  }
  return result;
}
```

## Security Checklist

### Webview Security
- [ ] CSP meta tag with `default-src 'none'`
- [ ] Script nonces (no `'unsafe-inline'` for scripts)
- [ ] `localResourceRoots` minimally scoped
- [ ] No `file://` URIs (use `asWebviewUri`)
- [ ] Message validation on both sides
- [ ] HTML sanitization for dynamic content

### Extension Security
- [ ] No shell command construction from user input
- [ ] Path traversal prevention
- [ ] Secrets stored in SecretStorage API
- [ ] Network requests validate responses
- [ ] Minimal required permissions in package.json

### Data Security
- [ ] No sensitive data in webview state
- [ ] Secrets never logged or displayed
- [ ] User data encrypted at rest (if stored)
- [ ] API keys in SecretStorage, not settings

## SecretStorage API

For sensitive data like API keys:

```typescript
// Store secret
await context.secrets.store('myApiKey', apiKeyValue);

// Retrieve secret
const apiKey = await context.secrets.get('myApiKey');

// Delete secret
await context.secrets.delete('myApiKey');
```

Never store secrets in:
- `workspaceState` or `globalState`
- Settings (`configuration` contribution)
- Files in the workspace
- Environment variables set by the extension
