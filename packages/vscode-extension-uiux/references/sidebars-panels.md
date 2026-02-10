# Sidebars and Panels Guide

## VS Code Layout Overview

```
┌─────────────────────────────────────────────────────────────────┐
│ Menu Bar                                                         │
├──────┬────────────────────────────────────────────────┬─────────┤
│      │                                                │         │
│ A    │             Editor Area                        │ Sec.    │
│ c    │                                                │ Side    │
│ t    ├────────────────────────────────────────────────┤ bar     │
│ i    │                                                │         │
│ v    │           Primary Sidebar                      │         │
│ i    │          (Explorer, Search,                    │         │
│ t    │           Source Control,                      │         │
│ y    │           Extensions, etc.)                    │         │
│      │                                                │         │
│ B    │                                                │         │
│ a    ├────────────────────────────────────────────────┴─────────┤
│ r    │              Panel (Terminal, Output, Problems)          │
└──────┴──────────────────────────────────────────────────────────┘
```

## View Containers

View containers appear in the Activity Bar and contain one or more views.

### Registering a View Container

```json
// package.json
{
  "contributes": {
    "viewsContainers": {
      "activitybar": [{
        "id": "myExtensionContainer",
        "title": "My Extension",
        "icon": "resources/icon.svg"
      }],
      "panel": [{
        "id": "myPanelContainer",
        "title": "My Panel",
        "icon": "resources/panel-icon.svg"
      }]
    }
  }
}
```

### Icon Requirements

- Format: SVG (preferred) or PNG
- Size: 24x24 pixels (Activity Bar), 16x16 (Panel)
- Colors: Use monochrome, `currentColor` for SVG
- Theme support: Use a single color that works on all backgrounds

```svg
<!-- Good: Uses currentColor -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path fill="currentColor" d="M12 2L2 7l10 5 10-5-10-5z"/>
</svg>
```

## Views

### Tree View in Sidebar

```json
{
  "contributes": {
    "views": {
      "myExtensionContainer": [{
        "id": "myTreeView",
        "name": "Explorer",
        "icon": "resources/tree-icon.svg",
        "contextualTitle": "My Extension Explorer",
        "visibility": "visible"
      }, {
        "id": "mySecondView",
        "name": "Details",
        "visibility": "collapsed"
      }]
    }
  }
}
```

### Webview View in Sidebar

```json
{
  "contributes": {
    "views": {
      "myExtensionContainer": [{
        "type": "webview",
        "id": "myWebviewView",
        "name": "Settings"
      }]
    }
  }
}
```

### View in Built-in Container

```json
{
  "contributes": {
    "views": {
      "explorer": [{
        "id": "myExplorerView",
        "name": "My Files"
      }],
      "scm": [{
        "id": "myScmView",
        "name": "My Changes"
      }],
      "debug": [{
        "id": "myDebugView",
        "name": "My Variables"
      }]
    }
  }
}
```

## View Actions

### Title Actions (Top of View)

```json
{
  "contributes": {
    "menus": {
      "view/title": [{
        "command": "myExtension.refresh",
        "when": "view == myTreeView",
        "group": "navigation"
      }, {
        "command": "myExtension.add",
        "when": "view == myTreeView",
        "group": "navigation"
      }, {
        "command": "myExtension.settings",
        "when": "view == myTreeView"
      }]
    },
    "commands": [{
      "command": "myExtension.refresh",
      "title": "Refresh",
      "icon": "$(refresh)"
    }, {
      "command": "myExtension.add",
      "title": "Add Item",
      "icon": "$(add)"
    }, {
      "command": "myExtension.settings",
      "title": "Settings"
    }]
  }
}
```

### Item Context Menu

```json
{
  "contributes": {
    "menus": {
      "view/item/context": [{
        "command": "myExtension.editItem",
        "when": "view == myTreeView && viewItem == editable",
        "group": "inline"
      }, {
        "command": "myExtension.deleteItem",
        "when": "view == myTreeView",
        "group": "context@1"
      }, {
        "command": "myExtension.copyItem",
        "when": "view == myTreeView",
        "group": "context@2"
      }]
    }
  }
}
```

### Menu Groups

| Group | Position | Description |
|-------|----------|-------------|
| `navigation` | Top | Always visible actions |
| `inline` | Item row | Inline action buttons |
| `context` | Context menu | Right-click menu items |
| `1_modification` | Numbered group | Custom ordering |

## Welcome View

Shown when the view has no content:

```json
{
  "contributes": {
    "viewsWelcome": [{
      "view": "myTreeView",
      "contents": "No items found.\n[Add your first item](command:myExtension.addItem)\n\nOr [learn more](https://example.com) about getting started.",
      "when": "myExtension.hasNoItems"
    }, {
      "view": "myTreeView",
      "contents": "Loading...",
      "when": "myExtension.isLoading"
    }]
  }
}
```

## Panel Views

### Output Channel

```typescript
const outputChannel = vscode.window.createOutputChannel('My Extension');

// Write to output
outputChannel.appendLine('Starting operation...');
outputChannel.append('Progress: ');

// Show the output panel
outputChannel.show(true); // true = preserve focus

// Clear output
outputChannel.clear();

// Dispose when done
context.subscriptions.push(outputChannel);
```

### Log Output Channel (Colored)

```typescript
const logChannel = vscode.window.createOutputChannel('My Extension', { log: true });

logChannel.trace('Detailed trace info');
logChannel.debug('Debug information');
logChannel.info('General information');
logChannel.warn('Warning message');
logChannel.error('Error message');
```

### Problems Panel

```typescript
const diagnosticCollection = vscode.languages.createDiagnosticCollection('myExtension');

// Add diagnostics
const diagnostics: vscode.Diagnostic[] = [
  new vscode.Diagnostic(
    new vscode.Range(0, 0, 0, 10),
    'This is an error',
    vscode.DiagnosticSeverity.Error
  ),
  new vscode.Diagnostic(
    new vscode.Range(1, 0, 1, 20),
    'This is a warning',
    vscode.DiagnosticSeverity.Warning
  )
];

diagnosticCollection.set(document.uri, diagnostics);

// Clear diagnostics
diagnosticCollection.clear();
```

### Webview in Panel

```json
{
  "contributes": {
    "views": {
      "panel": [{
        "type": "webview",
        "id": "myPanelWebview",
        "name": "Results"
      }]
    }
  }
}
```

## Status Bar

```typescript
// Create status bar item
const statusBarItem = vscode.window.createStatusBarItem(
  vscode.StatusBarAlignment.Right,
  100 // Priority (higher = more left)
);

statusBarItem.text = '$(check) Ready';
statusBarItem.tooltip = 'Extension is ready';
statusBarItem.command = 'myExtension.showStatus';
statusBarItem.backgroundColor = undefined; // Or new vscode.ThemeColor('statusBarItem.errorBackground')
statusBarItem.show();

// Update dynamically
function updateStatus(running: boolean) {
  if (running) {
    statusBarItem.text = '$(sync~spin) Running...';
    statusBarItem.backgroundColor = new vscode.ThemeColor('statusBarItem.warningBackground');
  } else {
    statusBarItem.text = '$(check) Ready';
    statusBarItem.backgroundColor = undefined;
  }
}

context.subscriptions.push(statusBarItem);
```

### Status Bar Priority

```
Left side (StatusBarAlignment.Left):
  Lower priority = more left

Right side (StatusBarAlignment.Right):
  Higher priority = more left (closer to center)
```

## View Visibility

### Programmatic Control

```typescript
// Show/hide views
vscode.commands.executeCommand('setContext', 'myExtension.showAdvanced', true);
```

```json
{
  "contributes": {
    "views": {
      "myContainer": [{
        "id": "advancedView",
        "name": "Advanced",
        "when": "myExtension.showAdvanced"
      }]
    }
  }
}
```

### Focus and Reveal

```typescript
// Focus a view
vscode.commands.executeCommand('myTreeView.focus');

// Reveal item in tree view
treeView.reveal(item, {
  select: true,
  focus: true,
  expand: true
});
```

## Best Practices

### 1. Respect User Layout

Don't force views to specific locations. Users can move views between:
- Primary Sidebar
- Secondary Sidebar
- Panel
- Editor area

### 2. Sensible Defaults

```json
{
  "views": {
    "myContainer": [{
      "id": "mainView",
      "name": "Main",
      "visibility": "visible"
    }, {
      "id": "auxiliaryView",
      "name": "Details",
      "visibility": "collapsed"
    }]
  }
}
```

### 3. Contextual Actions

Only show relevant actions:

```json
{
  "menus": {
    "view/item/context": [{
      "command": "myExtension.edit",
      "when": "view == myTreeView && viewItem =~ /editable/"
    }]
  }
}
```

### 4. Loading States

```typescript
// Show loading indicator
treeView.message = 'Loading...';

// Clear when done
treeView.message = undefined;

// Or use welcome view
vscode.commands.executeCommand('setContext', 'myExtension.isLoading', true);
```

### 5. Empty States

Always provide helpful empty states:

```json
{
  "viewsWelcome": [{
    "view": "myTreeView",
    "contents": "No projects found in this workspace.\n[Open Folder](command:vscode.openFolder)"
  }]
}
```

## Common Patterns

### Search/Filter in View

```typescript
class FilterableTreeProvider implements vscode.TreeDataProvider<Item> {
  private filterText = '';

  setFilter(text: string) {
    this.filterText = text.toLowerCase();
    this._onDidChangeTreeData.fire(undefined);
  }

  getChildren(element?: Item): Item[] {
    const items = this.getItems(element);
    if (!this.filterText) return items;

    return items.filter(item =>
      item.label.toLowerCase().includes(this.filterText)
    );
  }
}

// Register filter command
vscode.commands.registerCommand('myExtension.filter', async () => {
  const input = await vscode.window.showInputBox({
    prompt: 'Filter items',
    placeHolder: 'Type to filter...'
  });
  provider.setFilter(input || '');
});
```

### Expandable Sections

Use collapsible tree items to organize content:

```typescript
getTreeItem(element: Item): vscode.TreeItem {
  if (element.isSection) {
    return new vscode.TreeItem(
      element.label,
      element.expanded
        ? vscode.TreeItemCollapsibleState.Expanded
        : vscode.TreeItemCollapsibleState.Collapsed
    );
  }
  return new vscode.TreeItem(element.label);
}
```

### Badge Counter

```typescript
// Update view badge
treeView.badge = {
  value: itemCount,
  tooltip: `${itemCount} pending items`
};

// Clear badge
treeView.badge = undefined;
```
