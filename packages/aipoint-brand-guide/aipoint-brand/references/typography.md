# AIPoint Typography

## Font Stack

AIPoint uses modern sans-serif typography for a clean, professional, and tech-forward appearance.

### Primary Font: Inter

**Inter** is the primary typeface for AIPoint. It's a modern, highly legible sans-serif designed for screens.

- **Headings**: Inter Bold (700) or Semi-Bold (600)
- **Body**: Inter Regular (400)
- **Emphasis**: Inter Medium (500)

### Fallback Stack

```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
```

### Alternative Fonts

When Inter is not available:
- **Primary alternative**: Roboto
- **Secondary alternative**: Open Sans
- **System fallback**: -apple-system, Segoe UI

## Type Scale

| Element | Size | Weight | Line Height |
|---------|------|--------|-------------|
| H1 | 48px / 3rem | Bold (700) | 1.2 |
| H2 | 36px / 2.25rem | Bold (700) | 1.25 |
| H3 | 24px / 1.5rem | Semi-Bold (600) | 1.3 |
| H4 | 20px / 1.25rem | Semi-Bold (600) | 1.4 |
| Body Large | 18px / 1.125rem | Regular (400) | 1.6 |
| Body | 16px / 1rem | Regular (400) | 1.6 |
| Body Small | 14px / 0.875rem | Regular (400) | 1.5 |
| Caption | 12px / 0.75rem | Medium (500) | 1.4 |

## CSS Implementation

```css
/* AIPoint Typography */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: 16px;
  line-height: 1.6;
  color: var(--aipoint-white);
}

h1 { font-size: 3rem; font-weight: 700; line-height: 1.2; }
h2 { font-size: 2.25rem; font-weight: 700; line-height: 1.25; }
h3 { font-size: 1.5rem; font-weight: 600; line-height: 1.3; }
h4 { font-size: 1.25rem; font-weight: 600; line-height: 1.4; }
```

## Typography Rules

1. **Headings**: Use bold or semi-bold weights. Apply AIPoint gradient to key headings for emphasis when appropriate.

2. **Body text**: Maintain comfortable reading with regular weight and generous line-height (1.5-1.6).

3. **Contrast**: Ensure sufficient contrast - white text on dark backgrounds, dark text on light backgrounds.

4. **Hierarchy**: Establish clear visual hierarchy using size and weight, not color alone.

5. **Spacing**: Use consistent spacing between elements (multiples of 8px recommended).
