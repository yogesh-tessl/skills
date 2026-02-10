# Custom Editor Implementation Guide

## When to Use Custom Editors

Custom editors replace VS Code's default editor for specific file types:
- Binary files (images, databases, etc.)
- Domain-specific formats (diagrams, forms, etc.)
- Files needing visual editing (design files, charts)

## Editor Types

| Type | Document Model | Use Case |
|------|---------------|----------|
| `CustomTextEditorProvider` | VS Code's TextDocument | Text-based files with custom UI |
| `CustomEditorProvider` | Custom document model | Binary or complex file formats |

## CustomTextEditorProvider

Best for text files where you want custom visualization but leverage VS Code's text handling.

### Implementation

```typescript
import * as vscode from 'vscode';

class MyTextEditorProvider implements vscode.CustomTextEditorProvider {
  public static readonly viewType = 'myExtension.myTextEditor';

  constructor(private readonly context: vscode.ExtensionContext) {}

  async resolveCustomTextEditor(
    document: vscode.TextDocument,
    webviewPanel: vscode.WebviewPanel,
    _token: vscode.CancellationToken
  ): Promise<void> {
    // Setup webview
    webviewPanel.webview.options = {
      enableScripts: true,
      localResourceRoots: [this.context.extensionUri]
    };

    // Initial content
    webviewPanel.webview.html = this.getHtmlForWebview(webviewPanel.webview);

    // Send document content to webview
    function updateWebview() {
      webviewPanel.webview.postMessage({
        type: 'update',
        content: document.getText()
      });
    }

    // Handle document changes (external edits)
    const changeDocumentSubscription = vscode.workspace.onDidChangeTextDocument(e => {
      if (e.document.uri.toString() === document.uri.toString()) {
        updateWebview();
      }
    });

    webviewPanel.onDidDispose(() => {
      changeDocumentSubscription.dispose();
    });

    // Handle messages from webview
    webviewPanel.webview.onDidReceiveMessage(message => {
      switch (message.type) {
        case 'edit':
          this.updateDocument(document, message.content);
          return;
      }
    });

    // Initial update
    updateWebview();
  }

  private updateDocument(document: vscode.TextDocument, content: string): void {
    const edit = new vscode.WorkspaceEdit();
    edit.replace(
      document.uri,
      new vscode.Range(0, 0, document.lineCount, 0),
      content
    );
    vscode.workspace.applyEdit(edit);
  }

  private getHtmlForWebview(webview: vscode.Webview): string {
    const nonce = getNonce();
    const scriptUri = webview.asWebviewUri(
      vscode.Uri.joinPath(this.context.extensionUri, 'media', 'editor.js')
    );

    return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Security-Policy" content="
    default-src 'none';
    script-src 'nonce-${nonce}';
    style-src ${webview.cspSource} 'unsafe-inline';
  ">
</head>
<body>
  <div id="editor"></div>
  <script nonce="${nonce}" src="${scriptUri}"></script>
</body>
</html>`;
  }
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

### Registration

```typescript
// In activate()
context.subscriptions.push(
  vscode.window.registerCustomEditorProvider(
    MyTextEditorProvider.viewType,
    new MyTextEditorProvider(context),
    {
      webviewOptions: {
        retainContextWhenHidden: true
      },
      supportsMultipleEditorsPerDocument: false
    }
  )
);
```

```json
// package.json
{
  "contributes": {
    "customEditors": [{
      "viewType": "myExtension.myTextEditor",
      "displayName": "My Editor",
      "selector": [{
        "filenamePattern": "*.myext"
      }],
      "priority": "default"
    }]
  }
}
```

## CustomEditorProvider (Binary/Complex Files)

For files where you manage the document model yourself.

### Custom Document Model

```typescript
class MyDocument implements vscode.CustomDocument {
  uri: vscode.Uri;
  private _content: Uint8Array;
  private _savedContent: Uint8Array;

  private readonly _onDidChange = new vscode.EventEmitter<void>();
  readonly onDidChange = this._onDidChange.event;

  private readonly _onDidDispose = new vscode.EventEmitter<void>();
  readonly onDidDispose = this._onDidDispose.event;

  static async create(uri: vscode.Uri): Promise<MyDocument> {
    const content = await vscode.workspace.fs.readFile(uri);
    return new MyDocument(uri, content);
  }

  private constructor(uri: vscode.Uri, content: Uint8Array) {
    this.uri = uri;
    this._content = content;
    this._savedContent = content;
  }

  get content(): Uint8Array {
    return this._content;
  }

  makeEdit(newContent: Uint8Array): void {
    this._content = newContent;
    this._onDidChange.fire();
  }

  get isDirty(): boolean {
    return !this.arraysEqual(this._content, this._savedContent);
  }

  async save(cancellation: vscode.CancellationToken): Promise<void> {
    await vscode.workspace.fs.writeFile(this.uri, this._content);
    this._savedContent = this._content;
  }

  async saveAs(targetResource: vscode.Uri, cancellation: vscode.CancellationToken): Promise<void> {
    await vscode.workspace.fs.writeFile(targetResource, this._content);
    this._savedContent = this._content;
  }

  async revert(cancellation: vscode.CancellationToken): Promise<void> {
    const content = await vscode.workspace.fs.readFile(this.uri);
    this._content = content;
    this._savedContent = content;
    this._onDidChange.fire();
  }

  async backup(destination: vscode.Uri, cancellation: vscode.CancellationToken): Promise<vscode.CustomDocumentBackup> {
    await vscode.workspace.fs.writeFile(destination, this._content);
    return {
      id: destination.toString(),
      delete: async () => {
        try {
          await vscode.workspace.fs.delete(destination);
        } catch {
          // Ignore
        }
      }
    };
  }

  dispose(): void {
    this._onDidDispose.fire();
    this._onDidDispose.dispose();
    this._onDidChange.dispose();
  }

  private arraysEqual(a: Uint8Array, b: Uint8Array): boolean {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) {
      if (a[i] !== b[i]) return false;
    }
    return true;
  }
}
```

### Editor Provider

```typescript
class MyEditorProvider implements vscode.CustomEditorProvider<MyDocument> {
  public static readonly viewType = 'myExtension.binaryEditor';

  private readonly _onDidChangeCustomDocument = new vscode.EventEmitter<vscode.CustomDocumentEditEvent<MyDocument>>();
  readonly onDidChangeCustomDocument = this._onDidChangeCustomDocument.event;

  constructor(private readonly context: vscode.ExtensionContext) {}

  // Open document
  async openCustomDocument(
    uri: vscode.Uri,
    openContext: vscode.CustomDocumentOpenContext,
    _token: vscode.CancellationToken
  ): Promise<MyDocument> {
    const document = await MyDocument.create(uri);

    // Track document changes for dirty state
    const changeListener = document.onDidChange(() => {
      this._onDidChangeCustomDocument.fire({
        document,
        undo: async () => {
          // Implement undo
        },
        redo: async () => {
          // Implement redo
        }
      });
    });

    document.onDidDispose(() => changeListener.dispose());

    return document;
  }

  // Resolve editor view
  async resolveCustomEditor(
    document: MyDocument,
    webviewPanel: vscode.WebviewPanel,
    _token: vscode.CancellationToken
  ): Promise<void> {
    webviewPanel.webview.options = {
      enableScripts: true,
      localResourceRoots: [this.context.extensionUri]
    };

    webviewPanel.webview.html = this.getHtmlForWebview(webviewPanel.webview);

    // Send content to webview
    function updateWebview() {
      webviewPanel.webview.postMessage({
        type: 'update',
        content: Array.from(document.content) // Convert to array for JSON
      });
    }

    // Listen for document changes
    const changeListener = document.onDidChange(updateWebview);
    webviewPanel.onDidDispose(() => changeListener.dispose());

    // Handle messages from webview
    webviewPanel.webview.onDidReceiveMessage(message => {
      switch (message.type) {
        case 'edit':
          document.makeEdit(new Uint8Array(message.content));
          return;
      }
    });

    updateWebview();
  }

  // Save operations
  async saveCustomDocument(document: MyDocument, cancellation: vscode.CancellationToken): Promise<void> {
    await document.save(cancellation);
  }

  async saveCustomDocumentAs(document: MyDocument, destination: vscode.Uri, cancellation: vscode.CancellationToken): Promise<void> {
    await document.saveAs(destination, cancellation);
  }

  async revertCustomDocument(document: MyDocument, cancellation: vscode.CancellationToken): Promise<void> {
    await document.revert(cancellation);
  }

  async backupCustomDocument(document: MyDocument, context: vscode.CustomDocumentBackupContext, cancellation: vscode.CancellationToken): Promise<vscode.CustomDocumentBackup> {
    return document.backup(context.destination, cancellation);
  }

  private getHtmlForWebview(webview: vscode.Webview): string {
    // Similar to other webview implementations
    return `<!DOCTYPE html>...`;
  }
}
```

### Registration with Undo/Redo Support

```typescript
context.subscriptions.push(
  vscode.window.registerCustomEditorProvider(
    MyEditorProvider.viewType,
    new MyEditorProvider(context),
    {
      webviewOptions: { retainContextWhenHidden: true },
      supportsMultipleEditorsPerDocument: false
    }
  )
);
```

## Undo/Redo Implementation

### Edit Stack Pattern

```typescript
interface Edit {
  type: string;
  oldValue: any;
  newValue: any;
}

class DocumentWithEdits {
  private edits: Edit[] = [];
  private currentEdit = -1;
  private content: any;

  makeEdit(edit: Edit): void {
    // Clear any redo history
    this.edits = this.edits.slice(0, this.currentEdit + 1);

    // Apply edit
    this.applyEdit(edit);

    // Push to stack
    this.edits.push(edit);
    this.currentEdit = this.edits.length - 1;
  }

  undo(): Edit | undefined {
    if (this.currentEdit < 0) return undefined;

    const edit = this.edits[this.currentEdit];
    this.reverseEdit(edit);
    this.currentEdit--;

    return edit;
  }

  redo(): Edit | undefined {
    if (this.currentEdit >= this.edits.length - 1) return undefined;

    this.currentEdit++;
    const edit = this.edits[this.currentEdit];
    this.applyEdit(edit);

    return edit;
  }

  private applyEdit(edit: Edit): void {
    // Apply edit to content
  }

  private reverseEdit(edit: Edit): void {
    // Reverse edit on content
  }
}
```

### Integration with VS Code Undo Stack

```typescript
class MyEditorProvider implements vscode.CustomEditorProvider<MyDocument> {
  private readonly _onDidChangeCustomDocument = new vscode.EventEmitter<
    vscode.CustomDocumentContentChangeEvent<MyDocument> |
    vscode.CustomDocumentEditEvent<MyDocument>
  >();
  readonly onDidChangeCustomDocument = this._onDidChangeCustomDocument.event;

  private readonly editStack = new Map<string, Edit[]>();
  private readonly editIndex = new Map<string, number>();

  handleEdit(document: MyDocument, edit: Edit): void {
    const key = document.uri.toString();

    // Initialize if needed
    if (!this.editStack.has(key)) {
      this.editStack.set(key, []);
      this.editIndex.set(key, -1);
    }

    const stack = this.editStack.get(key)!;
    const index = this.editIndex.get(key)!;

    // Clear redo history
    stack.splice(index + 1);

    // Add edit
    stack.push(edit);
    this.editIndex.set(key, stack.length - 1);

    // Notify VS Code
    this._onDidChangeCustomDocument.fire({
      document,
      undo: async () => {
        const idx = this.editIndex.get(key)!;
        if (idx >= 0) {
          const editToUndo = stack[idx];
          this.reverseEdit(document, editToUndo);
          this.editIndex.set(key, idx - 1);
        }
      },
      redo: async () => {
        const idx = this.editIndex.get(key)!;
        if (idx < stack.length - 1) {
          this.editIndex.set(key, idx + 1);
          const editToRedo = stack[idx + 1];
          this.applyEdit(document, editToRedo);
        }
      }
    });
  }

  private applyEdit(document: MyDocument, edit: Edit): void {
    // Apply and sync to webview
  }

  private reverseEdit(document: MyDocument, edit: Edit): void {
    // Reverse and sync to webview
  }
}
```

## Editor Priority

```json
{
  "contributes": {
    "customEditors": [{
      "viewType": "myExtension.myEditor",
      "displayName": "My Editor",
      "selector": [{
        "filenamePattern": "*.png"
      }],
      "priority": "option"
    }]
  }
}
```

| Priority | Behavior |
|----------|----------|
| `default` | Opens by default for matching files |
| `option` | Available via "Open With" menu |

## Common Patterns

### Read-Only Preview

```typescript
class PreviewProvider implements vscode.CustomReadonlyEditorProvider {
  async openCustomDocument(uri: vscode.Uri): Promise<vscode.CustomDocument> {
    return { uri, dispose: () => {} };
  }

  async resolveCustomEditor(
    document: vscode.CustomDocument,
    webviewPanel: vscode.WebviewPanel
  ): Promise<void> {
    const content = await vscode.workspace.fs.readFile(document.uri);
    webviewPanel.webview.html = this.render(content);
  }

  private render(content: Uint8Array): string {
    // Generate preview HTML
    return `<!DOCTYPE html>...`;
  }
}
```

### Synchronizing Multiple Editors

When `supportsMultipleEditorsPerDocument: true`:

```typescript
class MultiViewEditorProvider implements vscode.CustomTextEditorProvider {
  private readonly webviewPanels = new Map<string, Set<vscode.WebviewPanel>>();

  resolveCustomTextEditor(
    document: vscode.TextDocument,
    webviewPanel: vscode.WebviewPanel
  ): void {
    const key = document.uri.toString();

    // Track panel
    if (!this.webviewPanels.has(key)) {
      this.webviewPanels.set(key, new Set());
    }
    this.webviewPanels.get(key)!.add(webviewPanel);

    webviewPanel.onDidDispose(() => {
      this.webviewPanels.get(key)?.delete(webviewPanel);
    });

    // Broadcast updates to all panels for this document
    webviewPanel.webview.onDidReceiveMessage(message => {
      if (message.type === 'edit') {
        // Apply edit
        this.updateDocument(document, message.content);

        // Notify all other panels
        for (const panel of this.webviewPanels.get(key) || []) {
          if (panel !== webviewPanel) {
            panel.webview.postMessage({
              type: 'externalUpdate',
              content: message.content
            });
          }
        }
      }
    });
  }
}
```
