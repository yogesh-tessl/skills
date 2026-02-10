---
name: vscode-extension-uiux
description: |
  Build secure, elegant, and accessible VS Code extensions with excellent UI/UX. Covers the complete Extension API including webviews, tree views, custom editors, sidebars, panels, and activity bar integration. Use this skill when: (1) Creating new VS Code extensions, (2) Building webview-based UIs, (3) Implementing tree views or custom editors, (4) Adding sidebar/panel contributions, (5) Ensuring extension security (CSP, message validation), (6) Theming and accessibility compliance, (7) Reviewing or improving existing extension UI/UX.
---

# VS Code Extension UI/UX Development

Build secure, beautiful, and accessible VS Code extensions following official guidelines.

## Quick Reference

| UI Contribution | When to Use | Reference |
|----------------|-------------|-----------|
| Tree View | Hierarchical data, file explorers, outlines | [tree-views.md](references/tree-views.md) |
| Webview | Custom UI beyond native API | [webviews.md](references/webviews.md) |
| Custom Editor | Replace default editor for file types | [custom-editors.md](references/custom-editors.md) |
| Sidebar View | Extension-specific panels | [sidebars-panels.md](references/sidebars-panels.md) |

## Core Principles

### 1. Native First, Webview Last

Prefer VS Code's native APIs over webviews:

```
Native API (preferred) → Tree Views → Webview Views → Full Webviews (last resort)
```

Native components are lighter, auto-themed, and accessible by default.

### 2. Security by Default

Every webview MUST have:
- Content Security Policy with nonces
- Validated message passing
- Restricted local resource roots

See [security.md](references/security.md) for implementation patterns.

### 3. Theme Integration

Use VS Code color tokens for automatic theme support:

```css
/* Always use CSS variables, never hardcode colors */
.my-element {
  color: var(--vscode-foreground);
  background: var(--vscode-editor-background);
  border: 1px solid var(--vscode-panel-border);
}
```

See [theming.md](references/theming.md) for complete token reference.

### 4. Accessibility Requirements

- All interactive elements keyboard navigable
- ARIA labels on focusable elements (concise, important info first)
- Color contrast ratios meeting WCAG 2.1 AA
- Screen reader announcements for dynamic content

See [accessibility.md](references/accessibility.md) for implementation guide.

## Extension Anatomy

```
my-extension/
├── package.json          # Manifest: activation, contributions, dependencies
├── src/
│   ├── extension.ts      # Entry: activate/deactivate functions
│   ├── providers/        # Tree, webview, editor providers
│   └── views/            # Webview HTML/CSS/JS
├── media/                # Icons, images, webview assets
└── resources/            # Static files (templates, schemas)
```

### package.json Contributions

```json
{
  "contributes": {
    "viewsContainers": {
      "activitybar": [{
        "id": "myExtension",
        "title": "My Extension",
        "icon": "media/icon.svg"
      }]
    },
    "views": {
      "myExtension": [{
        "id": "myTreeView",
        "name": "Explorer",
        "icon": "media/tree.svg"
      }]
    },
    "commands": [{
      "command": "myExtension.refresh",
      "title": "Refresh",
      "icon": "$(refresh)"
    }],
    "menus": {
      "view/title": [{
        "command": "myExtension.refresh",
        "when": "view == myTreeView",
        "group": "navigation"
      }]
    }
  }
}
```

## UI Component Selection Guide

```
Need to display...
│
├─ Hierarchical data? → Tree View
│   └─ With custom rendering? → Tree View + TreeItem.iconPath/description
│
├─ Simple list? → Tree View (flat)
│   └─ With actions? → TreeItem.command + context menu
│
├─ Form/settings UI? → Webview View (sidebar) or Settings contribution
│
├─ Rich content preview? → Webview Panel
│
├─ Custom file editor? → Custom Editor
│   └─ Text-based? → CustomTextEditorProvider
│   └─ Binary/complex? → CustomEditorProvider
│
├─ Status/info? → Status Bar Item
│
└─ Quick input? → QuickPick / InputBox API
```

## Common Patterns

### Tree View with Actions

```typescript
// Provider
class MyTreeProvider implements vscode.TreeDataProvider<MyItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<MyItem | undefined>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;

  refresh(): void {
    this._onDidChangeTreeData.fire(undefined);
  }

  getTreeItem(element: MyItem): vscode.TreeItem {
    const item = new vscode.TreeItem(element.label);
    item.iconPath = new vscode.ThemeIcon('file');
    item.contextValue = 'myItem'; // For context menu filtering
    item.command = { command: 'myExtension.openItem', title: 'Open', arguments: [element] };
    return item;
  }

  getChildren(element?: MyItem): MyItem[] {
    return element ? element.children : this.rootItems;
  }
}

// Registration
const provider = new MyTreeProvider();
vscode.window.registerTreeDataProvider('myTreeView', provider);
vscode.commands.registerCommand('myExtension.refresh', () => provider.refresh());
```

### Secure Webview Panel

```typescript
function createWebviewPanel(context: vscode.ExtensionContext) {
  const panel = vscode.window.createWebviewPanel(
    'myWebview',
    'My Panel',
    vscode.ViewColumn.One,
    {
      enableScripts: true,
      retainContextWhenHidden: true,
      localResourceRoots: [
        vscode.Uri.joinPath(context.extensionUri, 'media')
      ]
    }
  );

  panel.webview.html = getWebviewContent(panel.webview, context.extensionUri);

  // Handle messages from webview
  panel.webview.onDidReceiveMessage(
    message => {
      switch (message.command) {
        case 'alert':
          vscode.window.showInformationMessage(message.text);
          return;
      }
    },
    undefined,
    context.subscriptions
  );
}

function getWebviewContent(webview: vscode.Webview, extensionUri: vscode.Uri): string {
  const nonce = getNonce();
  const styleUri = webview.asWebviewUri(vscode.Uri.joinPath(extensionUri, 'media', 'style.css'));
  const scriptUri = webview.asWebviewUri(vscode.Uri.joinPath(extensionUri, 'media', 'main.js'));

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Security-Policy" content="
    default-src 'none';
    style-src ${webview.cspSource};
    script-src 'nonce-${nonce}';
    img-src ${webview.cspSource} https:;
    font-src ${webview.cspSource};
  ">
  <link href="${styleUri}" rel="stylesheet">
</head>
<body>
  <div id="app"></div>
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

## Message Passing (Extension ↔ Webview)

```typescript
// Extension side
panel.webview.postMessage({ type: 'update', data: myData });

panel.webview.onDidReceiveMessage(message => {
  // ALWAYS validate message structure
  if (typeof message !== 'object' || !message.type) return;

  switch (message.type) {
    case 'request':
      // Handle request
      break;
  }
});

// Webview side (main.js)
const vscode = acquireVsCodeApi();

// Restore state on load
const previousState = vscode.getState();
if (previousState) {
  restoreState(previousState);
}

window.addEventListener('message', event => {
  const message = event.data;
  switch (message.type) {
    case 'update':
      updateUI(message.data);
      // Persist state
      vscode.setState({ ...vscode.getState(), data: message.data });
      break;
  }
});

// Send message to extension
vscode.postMessage({ type: 'request', payload: data });
```

## UI Toolkit Options (Post-2025)

The official `@vscode/webview-ui-toolkit` was **deprecated January 2025**. Alternatives:

| Option | Pros | Cons |
|--------|------|------|
| **vscrui** | React components, maintained | React dependency |
| **Custom CSS** | Full control, no deps | More work, theme sync |
| **Codicons + CSS vars** | Native look, lightweight | Limited components |

For most cases, use VS Code CSS variables + Codicons for native appearance.

## Checklist Before Publishing

- [ ] CSP configured for all webviews
- [ ] All colors use VS Code CSS variables
- [ ] Keyboard navigation works throughout
- [ ] ARIA labels on all interactive elements
- [ ] Message validation on both sides
- [ ] localResourceRoots restricted appropriately
- [ ] Extension activates only when needed (activation events)
- [ ] Icons use proper formats (SVG preferred)
- [ ] Tested with light, dark, and high contrast themes
