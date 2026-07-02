---
name: qodly-page-builder
description: "Use when creating or modifying Qodly WebForm pages (.WebForm files). Create new pages from scratch, add/update components, modify layouts, set datasources, bind events, and apply styling. Triggers on 'create page', 'add component', 'patch page', 'modify WebForm', or 'update page structure'."
---

# Qodly Page Builder

Create and modify Qodly WebForm pages programmatically. WebForm files are JSON documents defining the page structure, components, styling, and data bindings.

## Design System Integration

**Always check for `.design/DESIGN.md` or `.design/*.DESIGN.md` in the project root.** If a design system exists, respect and use it for:
- Color palettes (primary, secondary, semantic colors)
- Typography (fonts, sizes, weights, line-height)
- Spacing scale (base unit, padding, margins, gaps)
- Border radius values
- Component styling patterns
- Elevation and shadows

**Consult the project's design system file for exact token values before styling any page.** Use hex colors with alpha channel (e.g., `#RRGGBBaa`) from the design system palette.

## Shared CSS Classes

Reusable CSS classes can be defined in **`Project/Sources/Shared/shared_css.json`** and will be automatically injected into all WebForms. This enables consistent styling across pages without duplication.

### Structure

The `shared_css.json` file contains a `classes` array with CSS class definitions:

```json
{
  "classes": [
    {
      "name": "variables",
      "content": ":root {\n  --primary-color: #6366F1;\n  --font-size: 16px;\n  --spacing: 1rem;\n}",
      "parentId": null,
      "id": "77wfY3Wds-PBJiEHhl61d"
    },
    {
      "name": "button-primary",
      "content": "self {\n  background-color: #6366F1;\n  color: #FFFFFF;\n  border-radius: 6px;\n  padding: 10px 24px;\n  cursor: pointer;\n}",
      "parentId": null,
      "id": "abc123xyz"
    }
  ]
}
```

### Key Rules

1. **CSS Variables**: Define shared tokens in a `variables` class using `:root { --var-name: value; }`
2. **`self` Placeholder**: At runtime, `self` is replaced with the actual class name (e.g., `self { ... }` becomes `.button-primary { ... }`)
3. **Automatic Injection**: All classes are injected into every WebForm page
4. **Use in Components**: Reference shared classes in component `className` props: `"className": "button-primary"`

### Best Practice: CSS Variables for Design Tokens

**Always define design tokens (colors, spacing, typography) as CSS variables in a `variables` class.** This enables:
- Single source of truth for design tokens
- Consistent styling across all WebForms
- Easy theme updates without modifying individual pages
- Cleaner, more maintainable code

**Define Variables in shared_css.json:**
```json
{
  "name": "variables",
  "content": ":root {\n  --primary-color: #6366F1;\n  --secondary-color: #FFFFFF;\n  --text-primary: #0A0A0A;\n  --text-secondary: #6B6B6B;\n  --border-color: #E8E8EC;\n  --border-radius-sm: 6px;\n  --border-radius-lg: 12px;\n  --spacing-xs: 4px;\n  --spacing-sm: 8px;\n  --spacing-md: 16px;\n  --spacing-lg: 24px;\n  --spacing-xl: 32px;\n}"
}
```

**Use Variables in WebForm Styles:**
```json
"style": {
  "backgroundColor": "var(--secondary-color)",
  "borderRadius": "var(--border-radius-lg)",
  "border": "1px solid var(--border-color)",
  "padding": "var(--spacing-lg)",
  "color": "var(--text-primary)"
}
```

**Reference in CSS Classes:**
```json
{
  "name": "button-primary",
  "content": "self {\n  background-color: var(--primary-color);\n  color: var(--secondary-color);\n  border-radius: var(--border-radius-sm);\n  padding: var(--spacing-sm) var(--spacing-md);\n  cursor: pointer;\n}"
}
```

### Example Workflow

**Define in shared_css.json:**
```json
{
  "name": "card-container",
  "content": "self {\n  background-color: #FFFFFF;\n  border: 1px solid #E8E8EC;\n  border-radius: 12px;\n  padding: 32px;\n  box-shadow: 0 1px 3px rgba(0,0,0,0.1);\n}"
}
```

**Use in WebForm:**
```json
"cardId": {
  "type": { "resolvedName": "StyleBox" },
  "props": { "className": "card-container" },
  "nodes": ["childId1", "childId2"]
}
```

**Result:**
```css
.card-container {
  background-color: #FFFFFF;
  border: 1px solid #E8E8EC;
  border-radius: 12px;
  padding: 32px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
```

## WebForm File Structure

A `.WebForm` file contains:

```json
{
  "metadata": {
    "v": "1.0",
    "datasources": [],
    "styles": [],
    "currentState": "root"
  },
  "components": {
    "ROOT": {
      "type": { "resolvedName": "Container" },
      "isCanvas": true,
      "props": { "className": "bg-white w-full px-6", "classNames": [], "events": [] },
      "displayName": "Page",
      "custom": {},
      "parent": "",
      "hidden": false,
      "nodes": ["childId1", "childId2"],
      "linkedNodes": {}
    },
    "childId1": {
      "type": { "resolvedName": "Text" },
      "isCanvas": false,
      "props": { "text": "Hello World" },
      "displayName": "Text",
      "custom": {},
      "parent": "ROOT",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    }
  }
}
```

## Key Concepts

### Component IDs
- `ROOT`: Reserved for the page root container — always has `"resolvedName": "Container"` with `"isCanvas": true`
- Child IDs: Random alphanumeric strings (e.g., `ilLeGDYpPq`, `vhT4PTTrHK`)
- IDs must be unique within a page

### Component Tree
- `nodes`: Array of child component IDs (direct children)
- `parent`: ID of the parent component
- `linkedNodes`: Special component relationships (e.g., Button → Icon, TextInput → Label/Input)
- **Nested Containers**: Use `StyleBox` for grouping components. Do not nest `Container` types.

### Props by Component Type

| Component | Key Props | Notes |
|-----------|-----------|-------|
| **Container** | `className`, `classNames`, `events`, `airyMode` | ROOT only; page container |
| **StyleBox** | `className`, `role`, `serverSideRef` | Nested container for grouping; use instead of Container |
| **Text** | `doc` (ProseMirror format), `datasource` | Rich text with formatting |
| **Button** | `text`, `iconPosition`, `style`, `events` | Can have linked Icon |
| **Icon** | `icon` (FontAwesome class), `classNames`, `events` | e.g., `fa-regular fa-star` |
| **TextInput** | `label`, `labelPosition`, `placeholder` | Composite: linked Label + Input |
| **Input** | `type`, `placeholder`, `className` | Child of TextInput |
| **Label** | `text`, `moveable`, `deletable` | Used in composite components |
| **Image** | `imgSrc`, `defaultImgSrc`, `altText` | Shared assets or external URLs |
| **FileUpload** | `text`, `iconPosition`, `style` | Can have linked Icon |
| **Radio** | `options`, `defaultValue`, `mode`, `type` | Array of `{id, label, value}` |
| **Slider** | `label`, `orientation` | Composite: linked Label + SliderContainer |
| **SelectInput** | `label`, `placeholder` | Composite: linked Label + Select |
| **Select** | `options`, `showEmptyOption` | Child of SelectInput |
| **Checkbox** | `label`, `type`, `size` | Composite: linked Label + CheckboxInput |
| **Tabs** | `tabs` (array), `variant` | Tab container with StyleBox children |
| **WebformLoader** | `webform` (page name) | Embed another WebForm page |

### Props Common to All Components

- `classNames`: Array of custom CSS classes
- `events`: Array of event handlers
- `hidden`: Boolean to hide component
- `style`: Object with CSS properties (`backgroundColor`, `borderRadius`, etc.) — **see React Inline Style Format below**
- `displayName`: Human-readable label in the builder

## React Inline Style Format

The `props.style` property must always be a **valid React CSS object** or omitted entirely. Follow these rules:

### Requirements

1. **Use camelCase property names** (NOT hyphenated):
   - ✅ `backgroundColor`, `borderRadius`, `marginBottom`, `fontSize`
   - ❌ `background-color`, `border-radius`, `margin-bottom` (invalid in React)

2. **Omit empty style objects**:
   - ✅ Don't include `"style": {}`
   - ❌ Never write empty style objects

3. **Use valid CSS values**:
   - Colors: hex format with optional alpha (`#FFFFFF`, `#6366F1cc`)
   - Sizes: numeric with units (`"10px"`, `"2rem"`, `"0.05em"`)
   - Numbers for unitless properties: `fontWeight: 700`, `opacity: 0.5`
   - Strings for keywords: `textAlign: "center"`, `overflow: "hidden"`

4. **Never mix Tailwind and inline styles for the same property**:
   - Use `className` for Tailwind classes: `"flex gap-4 px-6"`
   - Use `style` for dynamic or design-system values: `backgroundColor`, `color`, `borderRadius`

### Examples

**Correct:**
```json
"style": {
  "backgroundColor": "#FFFFFF",
  "borderRadius": "12px",
  "border": "1px solid #E8E8EC",
  "padding": "32px",
  "boxShadow": "0 1px 3px rgba(0,0,0,0.1)"
}
```

**Correct (no style when not needed):**
```json
"props": {
  "text": "Hello",
  "className": "flex items-center",
  "events": []
}
```

**Incorrect:**
```json
"style": {}  // ❌ Empty — omit entirely

"style": {
  "background-color": "#FFFFFF"  // ❌ Hyphenated — use backgroundColor
}

"style": {
  "padding": "10px 14px",
  "margin": "-1px"  // ❌ Negative values in margin shorthand — avoid
}
```

## Creating a New Page

### Minimal Page Template

```json
{
  "metadata": {
    "v": "1.0",
    "datasources": [],
    "styles": [],
    "currentState": "root"
  },
  "components": {
    "ROOT": {
      "type": { "resolvedName": "Container" },
      "isCanvas": true,
      "props": {
        "className": "bg-white w-full px-6",
        "classNames": [],
        "events": [],
        "airyMode": false
      },
      "displayName": "Page",
      "custom": {},
      "parent": "",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    }
  }
}
```

### Steps

1. Create the file at `Project/Sources/WebForms/<PageName>.WebForm`
2. Write metadata with v=1.0
3. Define ROOT container
4. Add child components to ROOT.nodes array
5. Define each child component in components object

## Patching a Existing Page

### Common Patches

**Add a component to the page:**
1. Generate unique component ID
2. Define component object in `components`
3. Set parent to container ID
4. Add component ID to parent's `nodes` array

**Update component props:**
1. Locate component by ID
2. Modify properties in `props` object
3. Update `style` or `className` as needed

**Add linked nodes (e.g., Button + Icon):**
1. Create the Icon component
2. Add Icon ID to Button's `linkedNodes.icon`
3. Set Icon's parent to Button ID

**Remove a component:**
1. Remove component ID from parent's `nodes` array
2. Delete component object from `components`
3. Remove any linkedNodes references

### Example: Add a Text Component

**Before:**
```json
"ROOT": {
  "nodes": ["comp1"],
  "linkedNodes": {}
}
```

**After:**
```json
"ROOT": {
  "nodes": ["comp1", "newTextId"],
  "linkedNodes": {}
},
"newTextId": {
  "type": { "resolvedName": "Text" },
  "isCanvas": false,
  "props": {
    "text": "New text",
    "classNames": [],
    "events": []
  },
  "displayName": "Text",
  "custom": { "__t": { "doc": [] } },
  "parent": "ROOT",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {}
}
```

## Complex Component Examples

### TextInput with Label (Composite Component)

```json
"textInputId": {
  "type": { "resolvedName": "TextInput" },
  "isCanvas": false,
  "props": {
    "label": "Email",
    "labelPosition": "left",
    "placeholder": "Enter email"
  },
  "parent": "ROOT",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {
    "label": "labelId",
    "input": "inputId"
  }
},
"labelId": {
  "type": { "resolvedName": "Label" },
  "isCanvas": false,
  "props": {
    "text": "Email",
    "moveable": false,
    "deletable": true,
    "style": {
      "color": "#0A0A0A",
      "fontWeight": "500",
      "fontSize": "14px",
      "marginBottom": "8px"
    }
  },
  "parent": "textInputId",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {}
},
"inputId": {
  "type": { "resolvedName": "Input" },
  "isCanvas": false,
  "props": {
    "type": "email",
    "placeholder": "Enter email",
    "className": "w-full",
    "style": {
      "borderRadius": "6px",
      "border": "1px solid #E8E8EC",
      "padding": "10px 14px",
      "fontSize": "14px"
    }
  },
  "parent": "textInputId",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {}
}
```

### Button with Icon

```json
"buttonId": {
  "type": { "resolvedName": "Button" },
  "isCanvas": false,
  "props": {
    "text": "Save",
    "iconPosition": "left",
    "events": []
  },
  "parent": "ROOT",
  "hidden": false,
  "nodes": [],
  "linkedNodes": { "icon": "iconId" }
},
"iconId": {
  "type": { "resolvedName": "Icon" },
  "isCanvas": false,
  "props": {
    "icon": "fa-regular fa-save",
    "events": []
  },
  "parent": "buttonId",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {}
}
```

### Radio Options

```json
"radioId": {
  "type": { "resolvedName": "Radio" },
  "isCanvas": false,
  "props": {
    "defaultValue": "option1",
    "mode": "single",
    "type": "tabs",
    "options": [
      { "id": "opt1", "label": "Option 1", "value": "option1" },
      { "id": "opt2", "label": "Option 2", "value": "option2" },
      { "id": "opt3", "label": "Option 3", "value": "option3" }
    ]
  },
  "parent": "ROOT",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {}
}
```

## Implementation Workflow

When creating or patching a page:

1. **Understand the layout**: Plan component hierarchy (parent-child relationships)
2. **Generate IDs**: Create short alphanumeric IDs for new components (8-12 chars)
3. **Build components**: Define each component object with type, props, parent, nodes
4. **Link composites**: Add linkedNodes for multi-part components (TextInput, Button+Icon)
5. **Set styles**: Use Tailwind classes in `className` or direct `style` object (see React Inline Style Format)
6. **Validate structure**: Ensure all nodes reference existing component IDs, no circular parents
7. **Validate styles**: Confirm all `props.style` use camelCase properties, valid CSS values, no empty objects
8. **Save the page**: Write JSON to `.WebForm` file with proper formatting

## Utilities

### Generate a Component ID
Use a short UUID or random alphanumeric: `ilLeGDYpPq`, `vhT4PTTrHK`, `xQRb7Catbg`

### Common Tailwind Classes
- Layout: `w-full`, `flex`, `grid`, `p-4`, `m-2`, `gap-2`
- Spacing: `px-6`, `py-4`, `mb-2`, `mt-2`, `mx-auto`
- Colors: `bg-white`, `bg-gray-100`, `text-gray-700`, `border-gray-200`
- Effects: `shadow-md`, `rounded-lg`, `border`, `opacity-50`

### Color Format
Hex with alpha: `#e73351ff` (RGBA as hex: RR, GG, BB, AA)

## Existing Pages

- **first.WebForm**: Dashboard with Text, Button, TextInput, Image, FileUpload, Radio, Checkbox, Select components
- **loader.WebForm**: Loading indicator page

Inspect existing pages for patterns and component configurations.
