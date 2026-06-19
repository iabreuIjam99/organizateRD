---
name: Antilles Premium Finance
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c5c6cd'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8f9097'
  outline-variant: '#44474d'
  surface-tint: '#b9c7e4'
  primary: '#b9c7e4'
  on-primary: '#233148'
  primary-container: '#0a192f'
  on-primary-container: '#74829d'
  inverse-primary: '#515f78'
  secondary: '#c1ffd5'
  on-secondary: '#00391f'
  secondary-container: '#05f297'
  on-secondary-container: '#00693f'
  tertiary: '#3cd7ff'
  on-tertiary: '#003642'
  tertiary-container: '#001c24'
  on-tertiary-container: '#008eab'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#b9c7e4'
  on-primary-fixed: '#0d1c32'
  on-primary-fixed-variant: '#39475f'
  secondary-fixed: '#55ffa9'
  secondary-fixed-dim: '#00e38d'
  on-secondary-fixed: '#002110'
  on-secondary-fixed-variant: '#005230'
  tertiary-fixed: '#b4ebff'
  tertiary-fixed-dim: '#3cd7ff'
  on-tertiary-fixed: '#001f27'
  on-tertiary-fixed-variant: '#004e5f'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Poppins
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Poppins
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Poppins
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Poppins
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  numeric-data:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: -0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
The design system is built to balance institutional stability with high-velocity financial innovation. It targets Dominican professionals and SME owners who require a sophisticated, "clutter-free" environment to manage liquidity and growth. 

The aesthetic is **Modern/Corporate Glassmorphism**. It utilizes deep, matte surfaces paired with vibrant, neon-inflected accents to signify digital-first banking. The emotional response is one of controlled power: the UI should feel heavy and grounded (trustworthy) but punctuated by light-emitting elements (innovation). 

Key principles:
- **Scannability:** Financial data is prioritized through scale and high-contrast color.
- **Architectural Depth:** Use of layering and blurs to separate navigation from transactional density.
- **Precision:** Tight alignment and clean geometry to reflect professional accounting standards.

## Colors
The palette is rooted in **Deep Navy Blue** for the primary brand identity, establishing a baseline of institutional trust. The background defaults to a **Charcoal/Graphite matte** in dark mode, which serves as a canvas for high-contrast accents.

- **Primary (#0A192F):** Used for deep backgrounds, sidebars, and structural headers.
- **Electric Mint (#2EFFA2):** Reserved for "success" states, growth indicators, and primary call-to-action buttons.
- **Neon Blue (#00D4FF):** Used for liquidity flows, active selections, and interactive data visualizations.
- **Gradients:** Subtle radial gradients (Primary to Background) should be used to provide depth in large empty states.

## Typography
The system uses a dual-type approach to separate brand impact from functional utility.

- **Headings (Poppins):** Used for page titles, section headers, and impactful marketing statements. It provides a geometric, modern friendliness.
- **Body & Data (Inter):** The workhorse for financial tables, input fields, and descriptions. It is selected for its high legibility in small sizes and its neutral, systematic feel.
- **Numerical Treatment:** All currency and balance displays must use `Inter` with a bold weight and tight letter spacing to ensure figures are the most legible element on the screen.

## Layout & Spacing
The design system employs a **Fluid Grid** model with a base-8 rhythm. 

- **Desktop:** 12-column grid with 24px gutters. Margins are generous (64px) to emphasize the premium, spacious feel.
- **Mobile:** 4-column grid with 16px margins.
- **Padding Logic:** Containers should use `md` (24px) internal padding to ensure financial data has "room to breathe," preventing the interface from feeling like a traditional, cramped spreadsheet.

## Elevation & Depth
Depth is created through **Glassmorphism** and tonal stacking rather than heavy drop shadows.

- **Level 1 (Base):** Charcoal matte background.
- **Level 2 (Containers):** Semi-transparent surfaces (`rgba(255, 255, 255, 0.03)`) with a `backdrop-filter: blur(10px)`.
- **Level 3 (Modals/Popovers):** Higher opacity glass with a thin 1px border (`rgba(255, 255, 255, 0.1)`) to define edges against the background.
- **Shadows:** Use extremely soft, large-radius shadows (0 20px 40px rgba(0,0,0,0.4)) only for elevated floating elements like cards or action menus.

## Shapes
A consistent 16px (`1rem`) border radius is applied to all primary containers and cards. This large radius softens the "serious" nature of finance, making the app feel approachable and modern.

- **Primary Buttons:** 16px radius to match containers.
- **Small Components (Chips/Badges):** Fully rounded (Pill) to distinguish them from structural containers.
- **Input Fields:** 12px radius to provide a slight visual distinction from the outer card holding them.

## Components
- **Buttons:** 
  - *Primary:* Electric Mint Green background with Navy Blue text. Bold and impactful.
  - *Secondary:* Ghost style with Neon Blue border and text.
- **Cards:** Utilize the glassmorphism effect. For SME dashboards, cards should have a subtle 1px top-border highlight to simulate light hitting the edge of a glass pane.
- **Inputs:** Darker than the container background to create a "punched-in" look. Use Neon Blue for the focus ring.
- **Chips:** Used for transaction categories (e.g., "Tax", "Liquidity"). Use low-opacity versions of the accent colors (e.g., Mint background at 10% opacity with 100% opacity text).
- **Financial Figures:** Always high-contrast white against the charcoal background. Profit/Growth uses Electric Mint; Loss/Expenses uses a soft Coral (functional red).
- **Lists:** Transaction lists should be "borderless," using subtle horizontal dividers (rgba(255, 255, 255, 0.05)) and generous vertical padding (16px) for scan-friendly reading.