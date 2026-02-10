# VS Code Theming Guide

## Core Principle

Never hardcode colors. Always use VS Code CSS variables for automatic theme support across light, dark, and high contrast themes.

## Essential Color Variables

### Base Colors

```css
/* Text */
--vscode-foreground                    /* Primary text */
--vscode-descriptionForeground         /* Secondary/muted text */
--vscode-errorForeground               /* Error text */
--vscode-disabledForeground            /* Disabled state */

/* Backgrounds */
--vscode-editor-background             /* Main editor background */
--vscode-sideBar-background            /* Sidebar background */
--vscode-panel-background              /* Panel background */
--vscode-input-background              /* Input field background */

/* Borders */
--vscode-panel-border                  /* Panel/section borders */
--vscode-input-border                  /* Input field borders */
--vscode-focusBorder                   /* Focus indicator */
```

### Interactive Elements

```css
/* Buttons */
--vscode-button-background
--vscode-button-foreground
--vscode-button-hoverBackground
--vscode-button-secondaryBackground
--vscode-button-secondaryForeground
--vscode-button-secondaryHoverBackground

/* Links */
--vscode-textLink-foreground
--vscode-textLink-activeForeground

/* Inputs */
--vscode-input-background
--vscode-input-foreground
--vscode-input-border
--vscode-input-placeholderForeground
--vscode-inputOption-activeBackground
--vscode-inputOption-activeBorder
--vscode-inputOption-activeForeground

/* Dropdowns */
--vscode-dropdown-background
--vscode-dropdown-foreground
--vscode-dropdown-border
--vscode-dropdown-listBackground
```

### Lists and Trees

```css
--vscode-list-activeSelectionBackground
--vscode-list-activeSelectionForeground
--vscode-list-hoverBackground
--vscode-list-hoverForeground
--vscode-list-inactiveSelectionBackground
--vscode-list-inactiveSelectionForeground
--vscode-list-highlightForeground
```

### Status Colors

```css
--vscode-editorError-foreground        /* Errors */
--vscode-editorWarning-foreground      /* Warnings */
--vscode-editorInfo-foreground         /* Info */
--vscode-testing-iconPassed            /* Success/passed */
--vscode-testing-iconFailed            /* Failed */
--vscode-testing-iconSkipped           /* Skipped/neutral */
```

### Badges and Notifications

```css
--vscode-badge-background
--vscode-badge-foreground
--vscode-notificationCenterHeader-background
--vscode-notifications-background
--vscode-notifications-foreground
--vscode-notifications-border
```

## Complete Webview Stylesheet

```css
/* Reset and base styles */
*,
*::before,
*::after {
  box-sizing: border-box;
}

body {
  margin: 0;
  padding: 16px;
  font-family: var(--vscode-font-family);
  font-size: var(--vscode-font-size);
  font-weight: var(--vscode-font-weight);
  color: var(--vscode-foreground);
  background-color: var(--vscode-editor-background);
  line-height: 1.4;
}

/* Typography */
h1, h2, h3, h4 {
  color: var(--vscode-foreground);
  margin-top: 0;
}

h1 { font-size: 1.5em; margin-bottom: 0.5em; }
h2 { font-size: 1.25em; margin-bottom: 0.4em; }
h3 { font-size: 1.1em; margin-bottom: 0.3em; }

p {
  margin: 0 0 1em;
}

a {
  color: var(--vscode-textLink-foreground);
  text-decoration: none;
}

a:hover,
a:active {
  color: var(--vscode-textLink-activeForeground);
}

code {
  font-family: var(--vscode-editor-font-family);
  font-size: var(--vscode-editor-font-size);
  background-color: var(--vscode-textCodeBlock-background);
  padding: 2px 4px;
  border-radius: 3px;
}

/* Buttons */
button,
.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 4px 12px;
  border: none;
  border-radius: 2px;
  font-family: inherit;
  font-size: var(--vscode-font-size);
  cursor: pointer;
  background-color: var(--vscode-button-background);
  color: var(--vscode-button-foreground);
}

button:hover {
  background-color: var(--vscode-button-hoverBackground);
}

button:focus {
  outline: 1px solid var(--vscode-focusBorder);
  outline-offset: 2px;
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

button.secondary {
  background-color: var(--vscode-button-secondaryBackground);
  color: var(--vscode-button-secondaryForeground);
}

button.secondary:hover {
  background-color: var(--vscode-button-secondaryHoverBackground);
}

/* Inputs */
input[type="text"],
input[type="number"],
input[type="search"],
textarea,
select {
  width: 100%;
  padding: 4px 8px;
  font-family: inherit;
  font-size: var(--vscode-font-size);
  color: var(--vscode-input-foreground);
  background-color: var(--vscode-input-background);
  border: 1px solid var(--vscode-input-border);
  border-radius: 2px;
}

input:focus,
textarea:focus,
select:focus {
  outline: 1px solid var(--vscode-focusBorder);
  outline-offset: -1px;
}

input::placeholder,
textarea::placeholder {
  color: var(--vscode-input-placeholderForeground);
}

/* Checkboxes */
input[type="checkbox"] {
  appearance: none;
  width: 16px;
  height: 16px;
  border: 1px solid var(--vscode-checkbox-border);
  background-color: var(--vscode-checkbox-background);
  border-radius: 2px;
  cursor: pointer;
}

input[type="checkbox"]:checked {
  background-color: var(--vscode-checkbox-selectBackground);
  border-color: var(--vscode-checkbox-selectBorder);
}

input[type="checkbox"]:checked::after {
  content: '✓';
  display: block;
  text-align: center;
  color: var(--vscode-checkbox-foreground);
  font-size: 12px;
  line-height: 14px;
}

/* Lists */
.list-item {
  padding: 4px 8px;
  cursor: pointer;
}

.list-item:hover {
  background-color: var(--vscode-list-hoverBackground);
  color: var(--vscode-list-hoverForeground);
}

.list-item.selected {
  background-color: var(--vscode-list-activeSelectionBackground);
  color: var(--vscode-list-activeSelectionForeground);
}

/* Badges */
.badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 18px;
  height: 18px;
  padding: 0 4px;
  font-size: 11px;
  font-weight: 600;
  border-radius: 9px;
  background-color: var(--vscode-badge-background);
  color: var(--vscode-badge-foreground);
}

/* Dividers */
hr,
.divider {
  border: none;
  border-top: 1px solid var(--vscode-panel-border);
  margin: 16px 0;
}

/* Cards/Panels */
.card {
  background-color: var(--vscode-editor-background);
  border: 1px solid var(--vscode-panel-border);
  border-radius: 4px;
  padding: 12px;
  margin-bottom: 12px;
}

/* Status indicators */
.status-error { color: var(--vscode-editorError-foreground); }
.status-warning { color: var(--vscode-editorWarning-foreground); }
.status-info { color: var(--vscode-editorInfo-foreground); }
.status-success { color: var(--vscode-testing-iconPassed); }

/* Scrollbars */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-track {
  background: var(--vscode-scrollbarSlider-background);
}

::-webkit-scrollbar-thumb {
  background: var(--vscode-scrollbarSlider-background);
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--vscode-scrollbarSlider-hoverBackground);
}

::-webkit-scrollbar-thumb:active {
  background: var(--vscode-scrollbarSlider-activeBackground);
}
```

## Codicons (VS Code Icons)

Use Codicons for consistent iconography:

```html
<!-- Include codicon CSS -->
<link href="${codiconsUri}" rel="stylesheet">

<!-- Use icons -->
<span class="codicon codicon-file"></span>
<span class="codicon codicon-folder"></span>
<span class="codicon codicon-refresh"></span>
<span class="codicon codicon-add"></span>
<span class="codicon codicon-close"></span>
<span class="codicon codicon-check"></span>
<span class="codicon codicon-error"></span>
<span class="codicon codicon-warning"></span>
<span class="codicon codicon-info"></span>
```

### Loading Codicons in TypeScript

```typescript
const codiconsUri = webview.asWebviewUri(
  vscode.Uri.joinPath(
    context.extensionUri,
    'node_modules',
    '@vscode/codicons',
    'dist',
    'codicon.css'
  )
);
```

### Common Codicons

| Icon | Class | Use Case |
|------|-------|----------|
| File | `codicon-file` | File items |
| Folder | `codicon-folder` | Folder items |
| Refresh | `codicon-refresh` | Refresh actions |
| Add | `codicon-add` | Add/create actions |
| Close | `codicon-close` | Close/remove actions |
| Check | `codicon-check` | Success/confirmed |
| Error | `codicon-error` | Error states |
| Warning | `codicon-warning` | Warning states |
| Info | `codicon-info` | Information |
| Search | `codicon-search` | Search functionality |
| Settings | `codicon-settings-gear` | Settings |
| Edit | `codicon-edit` | Edit actions |
| Trash | `codicon-trash` | Delete actions |
| Copy | `codicon-copy` | Copy actions |
| Link | `codicon-link-external` | External links |
| Loading | `codicon-loading codicon-modifier-spin` | Loading state |

## Testing Themes

Test your extension with these themes:

1. **Light**: Default Light+, Light (Visual Studio)
2. **Dark**: Default Dark+, Dark (Visual Studio)
3. **High Contrast**: High Contrast Light, High Contrast Dark

### Programmatic Theme Detection

```typescript
// Check current theme kind
const theme = vscode.window.activeColorTheme;
const isDark = theme.kind === vscode.ColorThemeKind.Dark;
const isHighContrast = theme.kind === vscode.ColorThemeKind.HighContrast ||
                       theme.kind === vscode.ColorThemeKind.HighContrastLight;

// Listen for theme changes
vscode.window.onDidChangeActiveColorTheme(theme => {
  panel.webview.postMessage({ type: 'themeChanged', isDark: theme.kind === vscode.ColorThemeKind.Dark });
});
```

## Custom Theme Contributions

Extensions can contribute their own colors:

```json
// package.json
{
  "contributes": {
    "colors": [{
      "id": "myExtension.specialBackground",
      "description": "Background for special elements",
      "defaults": {
        "dark": "#1e1e1e",
        "light": "#ffffff",
        "highContrast": "#000000",
        "highContrastLight": "#ffffff"
      }
    }]
  }
}
```

Use in CSS:
```css
.special-element {
  background-color: var(--vscode-myExtension-specialBackground);
}
```
