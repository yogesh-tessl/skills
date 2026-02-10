# VS Code Extension Accessibility Guide

## Core Requirements

1. **Keyboard Navigation**: All functionality accessible without a mouse
2. **Screen Reader Support**: ARIA labels and live regions for dynamic content
3. **Color Contrast**: Meet WCAG 2.1 AA standards (4.5:1 for text, 3:1 for UI)
4. **Focus Management**: Visible focus indicators, logical tab order

## Keyboard Navigation

### Tab Order

Ensure logical, visual tab order:

```html
<!-- Good: Natural reading order -->
<div class="toolbar">
  <button>Save</button>
  <button>Cancel</button>
</div>
<div class="content">
  <input type="text" placeholder="Name">
  <textarea placeholder="Description"></textarea>
</div>

<!-- Bad: tabindex disrupts order -->
<button tabindex="3">Third</button>
<button tabindex="1">First</button>
<button tabindex="2">Second</button>
```

### Focus Styles

Always provide visible focus indicators:

```css
/* Never do this */
*:focus { outline: none; }

/* Do this */
:focus {
  outline: 2px solid var(--vscode-focusBorder);
  outline-offset: 2px;
}

/* For custom focus styles */
:focus-visible {
  outline: 2px solid var(--vscode-focusBorder);
  outline-offset: 2px;
}
```

### Arrow Key Navigation

For lists and grids, implement arrow key navigation:

```javascript
const items = document.querySelectorAll('.list-item');
let currentIndex = 0;

document.addEventListener('keydown', (e) => {
  if (!['ArrowUp', 'ArrowDown', 'Home', 'End'].includes(e.key)) return;

  e.preventDefault();

  switch (e.key) {
    case 'ArrowDown':
      currentIndex = Math.min(currentIndex + 1, items.length - 1);
      break;
    case 'ArrowUp':
      currentIndex = Math.max(currentIndex - 1, 0);
      break;
    case 'Home':
      currentIndex = 0;
      break;
    case 'End':
      currentIndex = items.length - 1;
      break;
  }

  items[currentIndex].focus();
});
```

### Keyboard Shortcuts

Document and implement consistent shortcuts:

```typescript
// Extension-side command registration
vscode.commands.registerCommand('myExtension.focusView', () => {
  // Focus the extension's view
});

// Package.json keybinding
{
  "contributes": {
    "keybindings": [{
      "command": "myExtension.focusView",
      "key": "ctrl+shift+m",
      "mac": "cmd+shift+m"
    }]
  }
}
```

## ARIA Implementation

### Labels

```html
<!-- Interactive elements need labels -->
<button aria-label="Refresh list">
  <span class="codicon codicon-refresh"></span>
</button>

<!-- Form inputs -->
<label for="search-input">Search</label>
<input id="search-input" type="text" aria-describedby="search-help">
<span id="search-help">Press Enter to search, Escape to clear</span>

<!-- Or use aria-label for compact UI -->
<input type="text" aria-label="Search files" placeholder="Search...">
```

### Roles

```html
<!-- Navigation -->
<nav aria-label="File explorer">
  <ul role="tree">
    <li role="treeitem" aria-expanded="true">
      src
      <ul role="group">
        <li role="treeitem">index.ts</li>
        <li role="treeitem">utils.ts</li>
      </ul>
    </li>
  </ul>
</nav>

<!-- Toolbar -->
<div role="toolbar" aria-label="Editor actions">
  <button>Save</button>
  <button>Format</button>
</div>

<!-- Tablist -->
<div role="tablist" aria-label="Output panels">
  <button role="tab" aria-selected="true" aria-controls="output-panel">Output</button>
  <button role="tab" aria-selected="false" aria-controls="problems-panel">Problems</button>
</div>
<div id="output-panel" role="tabpanel" aria-labelledby="output-tab">
  Content here
</div>
```

### States and Properties

```html
<!-- Expandable items -->
<button aria-expanded="false" aria-controls="details-section">
  Show details
</button>
<div id="details-section" hidden>Details content</div>

<!-- Selection -->
<li role="option" aria-selected="true">Selected item</li>
<li role="option" aria-selected="false">Other item</li>

<!-- Disabled state -->
<button aria-disabled="true">Cannot click</button>

<!-- Loading state -->
<button aria-busy="true">
  <span class="codicon codicon-loading codicon-modifier-spin"></span>
  Loading...
</button>

<!-- Progress -->
<div role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">
  50% complete
</div>
```

### Live Regions

For dynamic content updates:

```html
<!-- Status announcements -->
<div role="status" aria-live="polite" aria-atomic="true" class="sr-only">
  <!-- Updated programmatically -->
</div>

<!-- Error announcements (more urgent) -->
<div role="alert" aria-live="assertive">
  Error: File not found
</div>
```

```javascript
// Update status for screen readers
function announceStatus(message) {
  const status = document.querySelector('[role="status"]');
  status.textContent = message;
}

// Usage
announceStatus('3 files found');
announceStatus('Search complete');
```

### Screen Reader Only Content

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

```html
<!-- Visible icon, text for screen readers -->
<button>
  <span class="codicon codicon-trash" aria-hidden="true"></span>
  <span class="sr-only">Delete item</span>
</button>
```

## Color and Contrast

### Minimum Ratios (WCAG 2.1 AA)

| Element Type | Minimum Ratio |
|-------------|---------------|
| Normal text | 4.5:1 |
| Large text (18px+ or 14px+ bold) | 3:1 |
| UI components, graphical objects | 3:1 |
| Focus indicators | 3:1 |

### Don't Rely on Color Alone

```html
<!-- Bad: Color-only indicator -->
<span style="color: red;">Error</span>

<!-- Good: Color + icon/text -->
<span class="error">
  <span class="codicon codicon-error" aria-hidden="true"></span>
  Error: Invalid input
</span>

<!-- Good: Color + pattern -->
<div class="status-indicator error">
  <span class="icon">✕</span>
  Failed
</div>
```

### Testing Tools

- VS Code's built-in Accessibility Help (F1 > "Open Accessibility Help")
- Chrome DevTools Accessibility panel
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- axe DevTools extension

## Extension API Accessibility

### TreeItem Accessibility

```typescript
class MyTreeItem extends vscode.TreeItem {
  constructor(label: string, description?: string) {
    super(label);
    this.description = description;

    // Accessibility info for screen readers
    this.accessibilityInformation = {
      label: `${label}${description ? ', ' + description : ''}`,
      role: 'treeitem'
    };
  }
}
```

### Status Bar Item Accessibility

```typescript
const statusBarItem = vscode.window.createStatusBarItem(
  vscode.StatusBarAlignment.Right,
  100
);
statusBarItem.text = '$(check) Tests Passed';
statusBarItem.tooltip = '12 tests passed';
statusBarItem.accessibilityInformation = {
  label: '12 tests passed',
  role: 'button'
};
statusBarItem.show();
```

### Progress Notifications

```typescript
// Accessible progress notification
vscode.window.withProgress({
  location: vscode.ProgressLocation.Notification,
  title: 'Processing files',
  cancellable: true
}, async (progress, token) => {
  for (let i = 0; i < 10; i++) {
    if (token.isCancellationRequested) break;

    progress.report({
      increment: 10,
      message: `Processing file ${i + 1} of 10`
    });

    await processFile(i);
  }
});
```

## Testing Checklist

### Keyboard Testing
- [ ] All interactive elements reachable via Tab
- [ ] Tab order matches visual order
- [ ] Focus visible on all elements
- [ ] Enter/Space activates buttons and links
- [ ] Escape closes modals/dropdowns
- [ ] Arrow keys navigate lists/trees

### Screen Reader Testing
- [ ] All interactive elements announced
- [ ] Labels are descriptive and concise
- [ ] State changes announced (expanded, selected, etc.)
- [ ] Error messages announced
- [ ] Progress updates announced

### Visual Testing
- [ ] Works in high contrast themes
- [ ] Text readable at 200% zoom
- [ ] No information conveyed by color alone
- [ ] Focus indicators visible

### Recommended Screen Readers

| Platform | Screen Reader |
|----------|---------------|
| Windows | NVDA (free), JAWS, Narrator |
| macOS | VoiceOver (built-in) |
| Linux | Orca |
