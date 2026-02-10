# AIPoint Color Palette

## Primary Colors

The AIPoint brand uses a distinctive cyan-to-green gradient that represents innovation, growth, and technology.

### Gradient Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| AIPoint Cyan | `#00E5CC` | rgb(0, 229, 204) | Gradient start (bottom) |
| AIPoint Teal | `#00D4B4` | rgb(0, 212, 180) | Gradient midpoint |
| AIPoint Green | `#3DED97` | rgb(61, 237, 151) | Gradient end (top) |
| AIPoint Bright Green | `#00FF88` | rgb(0, 255, 136) | Accent highlights |

### Neutral Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| AIPoint Black | `#000000` | rgb(0, 0, 0) | Primary background, text |
| AIPoint Dark | `#111111` | rgb(17, 17, 17) | Secondary background |
| AIPoint Gray | `#666666` | rgb(102, 102, 102) | Secondary text |
| AIPoint Light | `#F5F5F5` | rgb(245, 245, 245) | Light backgrounds |
| AIPoint White | `#FFFFFF` | rgb(255, 255, 255) | Text on dark, backgrounds |

## CSS Variables

```css
:root {
  /* Primary gradient */
  --aipoint-cyan: #00E5CC;
  --aipoint-teal: #00D4B4;
  --aipoint-green: #3DED97;
  --aipoint-bright-green: #00FF88;

  /* Gradient definition */
  --aipoint-gradient: linear-gradient(180deg, #3DED97 0%, #00D4B4 50%, #00E5CC 100%);
  --aipoint-gradient-horizontal: linear-gradient(90deg, #00E5CC 0%, #3DED97 100%);

  /* Neutrals */
  --aipoint-black: #000000;
  --aipoint-dark: #111111;
  --aipoint-gray: #666666;
  --aipoint-light: #F5F5F5;
  --aipoint-white: #FFFFFF;
}
```

## Color Application Rules

1. **Logo**: Always use the full gradient on dark backgrounds. Use solid AIPoint Cyan or Green on light backgrounds if gradient not possible.

2. **Backgrounds**: Prefer dark backgrounds (#000000 or #111111) for maximum brand impact. The gradient colors pop best against black.

3. **Text**: Use white (#FFFFFF) on dark backgrounds, black (#000000) on light backgrounds.

4. **Accents**: Use AIPoint Cyan or Green for links, buttons, and interactive elements.

5. **Gradients**: The gradient should flow from cyan (bottom/left) to green (top/right) to maintain consistency with the logo.
