# Webview Implementation Guide

## When to Use Webviews

Use webviews ONLY when VS Code's native API is inadequate:
- Rich HTML/CSS layouts
- Interactive visualizations
- Complex forms with validation
- Custom rendering (diagrams, charts)

**Avoid webviews for**: Simple lists (use Tree View), text display (use Output Channel), notifications (use VS Code notifications).

## Webview Types

| Type | Use Case | Location |
|------|----------|----------|
| Webview Panel | Full editor-area content | Editor group |
| Webview View | Sidebar/panel widget | Sidebar or Panel |
| Custom Editor | Replace file editor | Editor group |

## Webview Panel

### Basic Setup

```typescript
import * as vscode from 'vscode';

export function createWebviewPanel(context: vscode.ExtensionContext): vscode.WebviewPanel {
  const panel = vscode.window.createWebviewPanel(
    'myWebviewType',           // Identifies the type
    'My Webview',              // Title shown in tab
    vscode.ViewColumn.One,     // Editor column
    {
      enableScripts: true,
      retainContextWhenHidden: true,  // Keep state when hidden (memory cost)
      localResourceRoots: [
        vscode.Uri.joinPath(context.extensionUri, 'media'),
        vscode.Uri.joinPath(context.extensionUri, 'dist')
      ]
    }
  );

  panel.webview.html = getWebviewContent(panel.webview, context.extensionUri);

  return panel;
}
```

### HTML Template

```typescript
function getWebviewContent(webview: vscode.Webview, extensionUri: vscode.Uri): string {
  const nonce = getNonce();

  // Get URIs for resources
  const styleUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, 'media', 'style.css')
  );
  const scriptUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, 'media', 'main.js')
  );
  const codiconsUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, 'node_modules', '@vscode/codicons', 'dist', 'codicon.css')
  );

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="Content-Security-Policy" content="
    default-src 'none';
    style-src ${webview.cspSource} 'unsafe-inline';
    script-src 'nonce-${nonce}';
    img-src ${webview.cspSource} https: data:;
    font-src ${webview.cspSource};
  ">
  <link href="${codiconsUri}" rel="stylesheet">
  <link href="${styleUri}" rel="stylesheet">
  <title>My Webview</title>
</head>
<body>
  <div id="app">
    <h1>Hello from Webview</h1>
    <button id="action-btn">
      <span class="codicon codicon-play"></span>
      Run Action
    </button>
  </div>
  <script nonce="${nonce}" src="${scriptUri}"></script>
</body>
</html>`;
}

function getNonce(): string {
  let text = '';
  const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (let i = 0; i < 32; i++) {
    text += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return text;
}
```

## Webview View (Sidebar)

### Provider Implementation

```typescript
class MyWebviewViewProvider implements vscode.WebviewViewProvider {
  public static readonly viewType = 'myExtension.sidebarView';

  private _view?: vscode.WebviewView;

  constructor(private readonly _extensionUri: vscode.Uri) {}

  resolveWebviewView(
    webviewView: vscode.WebviewView,
    context: vscode.WebviewViewResolveContext,
    _token: vscode.CancellationToken
  ): void {
    this._view = webviewView;

    webviewView.webview.options = {
      enableScripts: true,
      localResourceRoots: [this._extensionUri]
    };

    webviewView.webview.html = this._getHtmlContent(webviewView.webview);

    // Handle messages
    webviewView.webview.onDidReceiveMessage(data => {
      switch (data.type) {
        case 'action':
          this.handleAction(data.payload);
          break;
      }
    });

    // Handle visibility changes
    webviewView.onDidChangeVisibility(() => {
      if (webviewView.visible) {
        // Refresh content when view becomes visible
      }
    });
  }

  public postMessage(message: any): void {
    this._view?.webview.postMessage(message);
  }

  private _getHtmlContent(webview: vscode.Webview): string {
    // Similar to panel HTML
    return `<!DOCTYPE html>...`;
  }

  private handleAction(payload: any): void {
    // Handle action from webview
  }
}
```

### Registration

```typescript
// In activate()
const provider = new MyWebviewViewProvider(context.extensionUri);
context.subscriptions.push(
  vscode.window.registerWebviewViewProvider(MyWebviewViewProvider.viewType, provider)
);
```

```json
// package.json
{
  "contributes": {
    "views": {
      "explorer": [{
        "type": "webview",
        "id": "myExtension.sidebarView",
        "name": "My View"
      }]
    }
  }
}
```

## Message Passing

### Extension → Webview

```typescript
// Extension side
panel.webview.postMessage({
  type: 'update',
  data: { items: [...] }
});

// Also can send to webview view
provider.postMessage({ type: 'refresh' });
```

### Webview → Extension

```javascript
// Webview side (main.js)
const vscode = acquireVsCodeApi();

// Send message
document.getElementById('action-btn').addEventListener('click', () => {
  vscode.postMessage({
    type: 'action',
    payload: { id: '123' }
  });
});
```

```typescript
// Extension side - handle message
panel.webview.onDidReceiveMessage(
  message => {
    // ALWAYS validate
    if (!message || typeof message.type !== 'string') return;

    switch (message.type) {
      case 'action':
        handleAction(message.payload);
        return;
      case 'error':
        vscode.window.showErrorMessage(message.text);
        return;
    }
  },
  undefined,
  context.subscriptions
);
```

### Two-way Communication Pattern

```typescript
// Extension: Request-response pattern
let messageId = 0;
const pendingRequests = new Map<number, { resolve: Function; reject: Function }>();

function requestFromWebview<T>(type: string, payload?: any): Promise<T> {
  return new Promise((resolve, reject) => {
    const id = messageId++;
    pendingRequests.set(id, { resolve, reject });
    panel.webview.postMessage({ type, payload, id });

    // Timeout
    setTimeout(() => {
      if (pendingRequests.has(id)) {
        pendingRequests.delete(id);
        reject(new Error('Request timeout'));
      }
    }, 5000);
  });
}

panel.webview.onDidReceiveMessage(message => {
  if (message.type === 'response' && pendingRequests.has(message.id)) {
    const { resolve, reject } = pendingRequests.get(message.id)!;
    pendingRequests.delete(message.id);
    if (message.error) {
      reject(new Error(message.error));
    } else {
      resolve(message.data);
    }
  }
});
```

```javascript
// Webview side
window.addEventListener('message', event => {
  const message = event.data;

  if (message.id !== undefined) {
    // This is a request that expects a response
    handleRequest(message).then(result => {
      vscode.postMessage({
        type: 'response',
        id: message.id,
        data: result
      });
    }).catch(error => {
      vscode.postMessage({
        type: 'response',
        id: message.id,
        error: error.message
      });
    });
  }
});
```

## State Management

### Webview State API

```javascript
// Webview side
const vscode = acquireVsCodeApi();

// Get previous state
const previousState = vscode.getState() || { count: 0 };

// Update UI from state
updateUI(previousState);

// Save state on changes
function incrementCount() {
  const state = vscode.getState() || { count: 0 };
  state.count++;
  vscode.setState(state);
  updateUI(state);
}

// State persists when webview is hidden (if retainContextWhenHidden: false)
// State survives VS Code restart
```

### Extension State (for data that outlives webview)

```typescript
// Use workspaceState or globalState
context.workspaceState.update('myData', data);
const data = context.workspaceState.get('myData');

// Sync state to webview on load
panel.webview.postMessage({
  type: 'init',
  data: context.workspaceState.get('myData')
});
```

## Lifecycle Management

### Panel Lifecycle

```typescript
let currentPanel: vscode.WebviewPanel | undefined;

function showPanel(context: vscode.ExtensionContext) {
  if (currentPanel) {
    // Reveal existing panel
    currentPanel.reveal(vscode.ViewColumn.One);
    return;
  }

  currentPanel = vscode.window.createWebviewPanel(
    'myPanel',
    'My Panel',
    vscode.ViewColumn.One,
    { enableScripts: true }
  );

  currentPanel.onDidDispose(
    () => {
      currentPanel = undefined;
    },
    null,
    context.subscriptions
  );

  currentPanel.onDidChangeViewState(
    e => {
      if (e.webviewPanel.visible) {
        // Panel became visible
        updatePanelContent();
      }
    },
    null,
    context.subscriptions
  );
}
```

### Serialization (Restore on Reload)

```typescript
// In activate()
if (vscode.window.registerWebviewPanelSerializer) {
  vscode.window.registerWebviewPanelSerializer('myPanel', {
    async deserializeWebviewPanel(webviewPanel: vscode.WebviewPanel, state: any) {
      // Restore the webview
      webviewPanel.webview.options = { enableScripts: true, ... };
      webviewPanel.webview.html = getWebviewContent(webviewPanel.webview, context.extensionUri);

      // Restore state
      webviewPanel.webview.postMessage({ type: 'restore', state });
    }
  });
}
```

## Using Frameworks

### React Setup

```typescript
// Build React app to dist/
// vite.config.js or webpack.config.js should output to extension's dist folder

function getWebviewContent(webview: vscode.Webview, extensionUri: vscode.Uri): string {
  const scriptUri = webview.asWebviewUri(
    vscode.Uri.joinPath(extensionUri, 'dist', 'webview.js')
  );

  return `<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Security-Policy" content="
    default-src 'none';
    script-src ${webview.cspSource};
    style-src ${webview.cspSource} 'unsafe-inline';
  ">
</head>
<body>
  <div id="root"></div>
  <script src="${scriptUri}"></script>
</body>
</html>`;
}
```

### React Component with VS Code Integration

```tsx
// src/webview/App.tsx
import { useState, useEffect } from 'react';

declare const acquireVsCodeApi: () => {
  postMessage: (message: any) => void;
  getState: () => any;
  setState: (state: any) => void;
};

const vscode = acquireVsCodeApi();

function App() {
  const [data, setData] = useState<any>(vscode.getState() || {});

  useEffect(() => {
    const handler = (event: MessageEvent) => {
      const message = event.data;
      switch (message.type) {
        case 'update':
          setData(message.data);
          vscode.setState(message.data);
          break;
      }
    };

    window.addEventListener('message', handler);
    return () => window.removeEventListener('message', handler);
  }, []);

  const handleClick = () => {
    vscode.postMessage({ type: 'action', payload: { ... } });
  };

  return (
    <div className="app">
      <button onClick={handleClick}>Action</button>
    </div>
  );
}
```

## Performance Tips

1. **Avoid `retainContextWhenHidden: true`** unless necessary (memory cost)
2. **Debounce frequent updates**
3. **Use virtual scrolling** for long lists
4. **Lazy load heavy content**
5. **Minimize message payload size**

```typescript
// Debounced updates
let updateTimeout: NodeJS.Timeout | undefined;

function updateWebview(data: any) {
  if (updateTimeout) {
    clearTimeout(updateTimeout);
  }
  updateTimeout = setTimeout(() => {
    panel.webview.postMessage({ type: 'update', data });
  }, 100);
}
```

## Common Issues

### Images Not Loading

```typescript
// Wrong: file:// won't work
const imgSrc = vscode.Uri.joinPath(extensionUri, 'media', 'image.png').toString();

// Correct: use asWebviewUri
const imgSrc = webview.asWebviewUri(
  vscode.Uri.joinPath(extensionUri, 'media', 'image.png')
).toString();
```

### Scripts Not Running

- Check CSP allows your script source
- Ensure nonce matches
- Check browser console for errors (Help > Toggle Developer Tools)

### Style Changes Not Applying

- Check CSP allows style source
- Verify `asWebviewUri` is used for CSS files
- Clear VS Code's webview cache (Developer: Reload Webviews)
