# Tree View Implementation Guide

## When to Use Tree Views

Tree views are ideal for:
- File explorers and hierarchical data
- Outlines and document structure
- Project/task lists
- Nested settings or configurations

Prefer tree views over webviews when displaying structured data.

## Basic Implementation

### 1. Define Data Model

```typescript
interface MyTreeItem {
  id: string;
  label: string;
  children?: MyTreeItem[];
  type: 'folder' | 'file';
  data?: any;
}
```

### 2. Create Tree Data Provider

```typescript
import * as vscode from 'vscode';

class MyTreeDataProvider implements vscode.TreeDataProvider<MyTreeItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<MyTreeItem | undefined | null | void>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;

  private data: MyTreeItem[] = [];

  constructor() {
    this.loadData();
  }

  refresh(): void {
    this._onDidChangeTreeData.fire();
  }

  refreshItem(item: MyTreeItem): void {
    this._onDidChangeTreeData.fire(item);
  }

  getTreeItem(element: MyTreeItem): vscode.TreeItem {
    const treeItem = new vscode.TreeItem(
      element.label,
      element.children && element.children.length > 0
        ? vscode.TreeItemCollapsibleState.Collapsed
        : vscode.TreeItemCollapsibleState.None
    );

    treeItem.id = element.id;
    treeItem.contextValue = element.type;
    treeItem.tooltip = `${element.label} (${element.type})`;

    // Icon based on type
    if (element.type === 'folder') {
      treeItem.iconPath = new vscode.ThemeIcon('folder');
    } else {
      treeItem.iconPath = new vscode.ThemeIcon('file');
    }

    // Command on click
    if (element.type === 'file') {
      treeItem.command = {
        command: 'myExtension.openItem',
        title: 'Open',
        arguments: [element]
      };
    }

    return treeItem;
  }

  getChildren(element?: MyTreeItem): MyTreeItem[] | Thenable<MyTreeItem[]> {
    if (element) {
      return element.children || [];
    }
    return this.data;
  }

  getParent(element: MyTreeItem): vscode.ProviderResult<MyTreeItem> {
    // Required for reveal() functionality
    return this.findParent(this.data, element.id);
  }

  private findParent(items: MyTreeItem[], targetId: string, parent?: MyTreeItem): MyTreeItem | undefined {
    for (const item of items) {
      if (item.id === targetId) {
        return parent;
      }
      if (item.children) {
        const found = this.findParent(item.children, targetId, item);
        if (found !== undefined) return found;
      }
    }
    return undefined;
  }

  private async loadData(): Promise<void> {
    // Load your data here
    this.data = [
      {
        id: '1',
        label: 'Source',
        type: 'folder',
        children: [
          { id: '1-1', label: 'index.ts', type: 'file' },
          { id: '1-2', label: 'utils.ts', type: 'file' }
        ]
      },
      { id: '2', label: 'README.md', type: 'file' }
    ];
    this.refresh();
  }
}
```

### 3. Register in package.json

```json
{
  "contributes": {
    "viewsContainers": {
      "activitybar": [{
        "id": "myExtensionViewContainer",
        "title": "My Extension",
        "icon": "resources/icon.svg"
      }]
    },
    "views": {
      "myExtensionViewContainer": [{
        "id": "myTreeView",
        "name": "Explorer",
        "icon": "resources/tree-icon.svg",
        "contextualTitle": "My Extension Explorer"
      }]
    },
    "menus": {
      "view/title": [{
        "command": "myExtension.refresh",
        "when": "view == myTreeView",
        "group": "navigation"
      }],
      "view/item/context": [{
        "command": "myExtension.editItem",
        "when": "view == myTreeView && viewItem == file",
        "group": "inline"
      }, {
        "command": "myExtension.deleteItem",
        "when": "view == myTreeView",
        "group": "context"
      }]
    }
  }
}
```

### 4. Register Provider in Extension

```typescript
export function activate(context: vscode.ExtensionContext) {
  const treeDataProvider = new MyTreeDataProvider();

  // Option 1: Simple registration
  vscode.window.registerTreeDataProvider('myTreeView', treeDataProvider);

  // Option 2: Get TreeView instance for advanced features
  const treeView = vscode.window.createTreeView('myTreeView', {
    treeDataProvider,
    showCollapseAll: true,
    canSelectMany: true
  });

  // Register commands
  context.subscriptions.push(
    vscode.commands.registerCommand('myExtension.refresh', () => {
      treeDataProvider.refresh();
    }),
    vscode.commands.registerCommand('myExtension.openItem', (item: MyTreeItem) => {
      // Handle item open
    }),
    vscode.commands.registerCommand('myExtension.editItem', (item: MyTreeItem) => {
      // Handle item edit
    }),
    vscode.commands.registerCommand('myExtension.deleteItem', (item: MyTreeItem) => {
      // Handle item delete
    }),
    treeView
  );
}
```

## Advanced Features

### Drag and Drop

```typescript
class MyTreeDataProvider implements vscode.TreeDataProvider<MyTreeItem>, vscode.TreeDragAndDropController<MyTreeItem> {
  dropMimeTypes = ['application/vnd.code.tree.myTreeView'];
  dragMimeTypes = ['text/uri-list'];

  async handleDrag(source: readonly MyTreeItem[], dataTransfer: vscode.DataTransfer, token: vscode.CancellationToken): Promise<void> {
    dataTransfer.set('application/vnd.code.tree.myTreeView', new vscode.DataTransferItem(source));
  }

  async handleDrop(target: MyTreeItem | undefined, dataTransfer: vscode.DataTransfer, token: vscode.CancellationToken): Promise<void> {
    const transferItem = dataTransfer.get('application/vnd.code.tree.myTreeView');
    if (!transferItem) return;

    const draggedItems = transferItem.value as MyTreeItem[];
    // Move items to target
    this.moveItems(draggedItems, target);
    this.refresh();
  }

  private moveItems(items: MyTreeItem[], target: MyTreeItem | undefined): void {
    // Implement move logic
  }
}

// Register with drag and drop
const treeView = vscode.window.createTreeView('myTreeView', {
  treeDataProvider,
  dragAndDropController: treeDataProvider
});
```

### Reveal and Focus

```typescript
// Reveal a specific item
async function revealItem(item: MyTreeItem) {
  await treeView.reveal(item, {
    select: true,
    focus: true,
    expand: true
  });
}

// Listen to selection changes
treeView.onDidChangeSelection(e => {
  console.log('Selected:', e.selection);
});

// Listen to visibility changes
treeView.onDidChangeVisibility(e => {
  if (e.visible) {
    // View became visible, maybe refresh data
  }
});
```

### Welcome View

When the tree is empty:

```json
{
  "contributes": {
    "viewsWelcome": [{
      "view": "myTreeView",
      "contents": "No items found.\n[Add Item](command:myExtension.addItem)"
    }]
  }
}
```

### Badge (Item Count)

```typescript
// Update the view badge
treeView.badge = {
  value: itemCount,
  tooltip: `${itemCount} items`
};

// Remove badge
treeView.badge = undefined;
```

### Description and Decorations

```typescript
getTreeItem(element: MyTreeItem): vscode.TreeItem {
  const item = new vscode.TreeItem(element.label);

  // Description appears after label (dimmed)
  item.description = element.modified ? 'Modified' : undefined;

  // Highlight color (for file decorations)
  item.resourceUri = vscode.Uri.parse(`myscheme:/${element.id}`);

  return item;
}
```

Register file decoration provider:

```typescript
class MyDecorationProvider implements vscode.FileDecorationProvider {
  provideFileDecoration(uri: vscode.Uri): vscode.FileDecoration | undefined {
    if (uri.scheme !== 'myscheme') return;

    // Add badge/color based on URI
    return {
      badge: 'M',
      color: new vscode.ThemeColor('gitDecoration.modifiedResourceForeground'),
      tooltip: 'Modified'
    };
  }
}

vscode.window.registerFileDecorationProvider(new MyDecorationProvider());
```

## Custom Icons

### ThemeIcon (Codicons)

```typescript
// Use built-in codicons
item.iconPath = new vscode.ThemeIcon('file');
item.iconPath = new vscode.ThemeIcon('folder');
item.iconPath = new vscode.ThemeIcon('symbol-class');
item.iconPath = new vscode.ThemeIcon('debug-start');

// With color
item.iconPath = new vscode.ThemeIcon('circle-filled', new vscode.ThemeColor('charts.green'));
```

### Custom SVG Icons

```typescript
// Different icons for light/dark themes
item.iconPath = {
  light: vscode.Uri.joinPath(context.extensionUri, 'resources', 'light', 'icon.svg'),
  dark: vscode.Uri.joinPath(context.extensionUri, 'resources', 'dark', 'icon.svg')
};
```

### Icon by File Type

```typescript
// Use VS Code's file icon theme
item.resourceUri = vscode.Uri.file('/path/to/file.ts');
// Omit iconPath to use file icon theme
```

## Performance Tips

1. **Lazy loading**: Only load children when expanded
2. **Virtual scrolling**: VS Code handles this automatically
3. **Debounce refresh**: Don't refresh on every change

```typescript
private refreshTimeout: NodeJS.Timeout | undefined;

debouncedRefresh(): void {
  if (this.refreshTimeout) {
    clearTimeout(this.refreshTimeout);
  }
  this.refreshTimeout = setTimeout(() => {
    this.refresh();
  }, 100);
}
```

4. **Partial updates**: Refresh specific items when possible

```typescript
// Instead of full refresh
this._onDidChangeTreeData.fire(changedItem);
```

## Common Patterns

### Search/Filter

```typescript
class FilterableTreeProvider implements vscode.TreeDataProvider<MyTreeItem> {
  private filter: string = '';

  setFilter(filter: string): void {
    this.filter = filter.toLowerCase();
    this.refresh();
  }

  getChildren(element?: MyTreeItem): MyTreeItem[] {
    const children = element ? element.children : this.rootItems;
    if (!this.filter) return children || [];

    return (children || []).filter(item =>
      item.label.toLowerCase().includes(this.filter) ||
      this.hasMatchingDescendant(item)
    );
  }

  private hasMatchingDescendant(item: MyTreeItem): boolean {
    if (!item.children) return false;
    return item.children.some(child =>
      child.label.toLowerCase().includes(this.filter) ||
      this.hasMatchingDescendant(child)
    );
  }
}
```

### Checkboxes

```typescript
getTreeItem(element: MyTreeItem): vscode.TreeItem {
  const item = new vscode.TreeItem(element.label);

  item.checkboxState = element.isChecked
    ? vscode.TreeItemCheckboxState.Checked
    : vscode.TreeItemCheckboxState.Unchecked;

  return item;
}

// Handle checkbox changes
treeView.onDidChangeCheckboxState(e => {
  for (const [item, state] of e.items) {
    item.isChecked = state === vscode.TreeItemCheckboxState.Checked;
  }
  // Save state
});
```
