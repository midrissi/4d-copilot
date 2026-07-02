# Qodly Page Builder - Practical Examples

This guide shows real examples of creating and modifying pages in your Qodly app. **Consult your project's design system (`.design/*.DESIGN.md`) for the exact color, spacing, and typography tokens before styling pages.**

## Example 1: Create a Simple Welcome Page

**File**: `Project/Sources/WebForms/welcome.WebForm`

**Goal**: Create a page with a title, description, and call-to-action button. Refer to your project's design system for the exact colors and spacing.

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
        "className": "w-full min-h-screen flex flex-col items-center justify-center px-6",
        "classNames": [],
        "events": [],
        "airyMode": false,
        "style": {
          "backgroundColor": "#FAFAFAff"
        }
      },
      "displayName": "Page",
      "custom": {},
      "parent": "",
      "hidden": false,
      "nodes": ["welcome-title", "welcome-desc", "welcome-button"],
      "linkedNodes": {}
    },
    "welcome-title": {
      "type": { "resolvedName": "Text" },
      "isCanvas": false,
      "props": {
        "text": "Welcome to Qodly",
        "classNames": [],
        "events": [],
        "style": {
          "fontSize": "60px",
          "fontWeight": "700",
          "color": "#0A0A0Aff",
          "letterSpacing": "-0.03em",
          "marginBottom": "16px"
        }
      },
      "displayName": "Title",
      "custom": { "__t": { "doc": [] } },
      "parent": "ROOT",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "welcome-desc": {
      "type": { "resolvedName": "Text" },
      "isCanvas": false,
      "props": {
        "text": "Build amazing applications with ease",
        "classNames": [],
        "events": [],
        "style": {
          "fontSize": "15px",
          "color": "#6B6B6Bff",
          "marginBottom": "32px"
        }
      },
      "displayName": "Description",
      "custom": { "__t": { "doc": [] } },
      "parent": "ROOT",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "welcome-button": {
      "type": { "resolvedName": "Button" },
      "isCanvas": false,
      "props": {
        "text": "Get Started",
        "classNames": [],
        "events": [],
        "iconPosition": "hidden",
        "style": {
          "backgroundColor": "#6366F1ff",
          "color": "#FFFFFFff",
          "padding": "10px 20px",
          "borderRadius": "6px",
          "fontWeight": "500"
        }
      },
      "displayName": "Button",
      "custom": {},
      "parent": "ROOT",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    }
  }
}
```

**Design Notes**:
- Background uses Genesis `#FAFAFA` (light warm gray)
- Title is 60px bold with `-0.03em` letter spacing (Genesis headline style)
- Description uses text secondary color `#6B6B6B`
- Button uses primary indigo `#6366F1` with 6px border radius

---

## Example 2: Create a Form Page (Login)

**File**: `Project/Sources/WebForms/login.WebForm`

**Goal**: Create a login form with email and password fields. Apply your project's design system tokens for colors, spacing, and borders.

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
        "className": "w-full min-h-screen flex items-center justify-center px-6",
        "classNames": [],
        "events": [],
        "airyMode": false,
        "style": {
          "backgroundColor": "#FAFAFAff"
        }
      },
      "displayName": "Page",
      "custom": {},
      "parent": "",
      "hidden": false,
      "nodes": ["form-container"],
      "linkedNodes": {}
    },
    "form-container": {
      "type": { "resolvedName": "Container" },
      "isCanvas": true,
      "props": {
        "className": "w-96",
        "classNames": [],
        "events": [],
        "airyMode": false,
        "style": {
          "backgroundColor": "#FFFFFFff",
          "borderRadius": "12px",
          "borderWidth": "1px",
          "borderColor": "#E8E8ECff",
          "padding": "32px"
        }
      },
      "displayName": "Form Container",
      "custom": {},
      "parent": "ROOT",
      "hidden": false,
      "nodes": ["form-title", "email-input", "password-input", "login-button"],
      "linkedNodes": {}
    },
    "form-title": {
      "type": { "resolvedName": "Text" },
      "isCanvas": false,
      "props": {
        "text": "Sign In",
        "classNames": [],
        "events": [],
        "style": {
          "fontSize": "32px",
          "fontWeight": "700",
          "color": "#0A0A0Aff",
          "letterSpacing": "-0.03em",
          "marginBottom": "24px"
        }
      },
      "displayName": "Title",
      "custom": { "__t": { "doc": [] } },
      "parent": "form-container",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "email-input": {
      "type": { "resolvedName": "TextInput" },
      "isCanvas": false,
      "props": {
        "label": "Email",
        "labelPosition": "top",
        "placeholder": "you@example.com",
        "style": { "marginBottom": "16px" }
      },
      "displayName": "Email Input",
      "custom": {},
      "parent": "form-container",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {
        "label": "email-label",
        "input": "email-field"
      }
    },
    "email-label": {
      "type": { "resolvedName": "Label" },
      "isCanvas": false,
      "props": { 
        "text": "Email",
        "moveable": false,
        "deletable": true,
        "style": {
          "fontSize": "14px",
          "fontWeight": "500",
          "color": "#0A0A0Aff",
          "marginBottom": "8px"
        }
      },
      "displayName": "Label",
      "custom": {},
      "parent": "email-input",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "email-field": {
      "type": { "resolvedName": "Input" },
      "isCanvas": false,
      "props": {
        "type": "email",
        "placeholder": "you@example.com",
        "className": "w-full bg-transparent",
        "style": {
          "borderRadius": "6px",
          "borderWidth": "1px",
          "borderColor": "#E8E8ECff",
          "padding": "10px 14px",
          "fontSize": "14px"
        }
      },
      "displayName": "Input",
      "custom": {},
      "parent": "email-input",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "password-input": {
      "type": { "resolvedName": "TextInput" },
      "isCanvas": false,
      "props": {
        "label": "Password",
        "labelPosition": "top",
        "placeholder": "Enter your password",
        "style": { "marginBottom": "24px" }
      },
      "displayName": "Password Input",
      "custom": {},
      "parent": "form-container",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {
        "label": "password-label",
        "input": "password-field"
      }
    },
    "password-label": {
      "type": { "resolvedName": "Label" },
      "isCanvas": false,
      "props": {
        "text": "Password",
        "moveable": false,
        "deletable": true,
        "style": {
          "fontSize": "14px",
          "fontWeight": "500",
          "color": "#0A0A0Aff",
          "marginBottom": "8px"
        }
      },
      "displayName": "Label",
      "custom": {},
      "parent": "password-input",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "password-field": {
      "type": { "resolvedName": "Input" },
      "isCanvas": false,
      "props": {
        "type": "password",
        "placeholder": "Enter your password",
        "className": "w-full bg-transparent",
        "style": {
          "borderRadius": "6px",
          "borderWidth": "1px",
          "borderColor": "#E8E8ECff",
          "padding": "10px 14px",
          "fontSize": "14px"
        }
      },
      "displayName": "Input",
      "custom": {},
      "parent": "password-input",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    },
    "login-button": {
      "type": { "resolvedName": "Button" },
      "isCanvas": false,
      "props": {
        "text": "Sign In",
        "classNames": [],
        "events": [],
        "iconPosition": "hidden",
        "style": {
          "backgroundColor": "#6366F1ff",
          "color": "#FFFFFFff",
          "width": "100%",
          "padding": "10px",
          "borderRadius": "6px",
          "fontWeight": "500",
          "fontSize": "15px"
        }
      },
      "displayName": "Button",
      "custom": {},
      "parent": "form-container",
      "hidden": false,
      "nodes": [],
      "linkedNodes": {}
    }
  }
}
```

**Design Notes**: Use your design system for:
- Page background color
- Form card surface color and border color
- Typography sizing for labels and title
- Input styling: border radius and border color
- Button: primary color from your palette

---

## Example 3: Add a New Component to an Existing Page

**Task**: Add a dismiss button to the top-right of `first.WebForm`

**Steps**:

1. Generate a new component ID: `btn-dismiss-xyz`
2. Create the button component object with appropriate styling
3. Add button ID to `ROOT.nodes` array
4. Apply positioning styles to place it top-right

**Button Component** (add to components object):

```json
"btn-dismiss-xyz": {
  "type": { "resolvedName": "Button" },
  "isCanvas": false,
  "props": {
    "text": "Dismiss",
    "iconPosition": "hidden",
    "style": {
      "position": "absolute",
      "top": "16px",
      "right": "24px",
      "backgroundColor": "#EF4444ff",
      "borderRadius": "6px",
      "padding": "8px 16px",
      "fontWeight": "500",
      "fontSize": "14px"
    }
  },
  "displayName": "Dismiss Button",
  "custom": {},
  "parent": "ROOT",
  "hidden": false,
  "nodes": [],
  "linkedNodes": {}
}
```

**Design Notes**: Use your design system's error/destructive color for the button background. Check your design system for:
- Destructive action color
- Button border radius standard
- Component padding scale

---

## Example 4: Modify Component Props (Patch)

**Task**: Change a button color from error to success on `first.WebForm`

**Before**:
```json
"vhT4PTTrHK": {
  "props": {
    "style": { "backgroundColor": "#EF4444ff" }
  }
}
```

**After** (using Genesis success color):
```json
"vhT4PTTrHK": {
  "props": {
    "style": { "backgroundColor": "#10B981ff" }
  }
}
```

**Design Notes**:
- Check your design system for error and success color tokens
- Always use hex format with alpha channel: `#RRGGBBaa`

---

## Example 5: Hide/Show a Component

**Task**: Hide the Text component `ilLeGDYpPq` on `first.WebForm`

**Change**: Set `hidden: true`

```json
"ilLeGDYpPq": {
  "hidden": true
}
```

---

## Common Patterns

Use these patterns with your project's design system tokens:

### Hero Section
- Container with `#FAFAFAff` background
- Large centered text (60px headline bold) in `#0A0A0Aff`
- Primary indigo button (`#6366F1ff`) with 6px radius

### Card Layout
- Nested white container (`#FFFFFFff`) with `#E8E8ECff` border
- 12px border radius
- Padding: 24-32px
- Hover: subtle shadow `0 8px 30px rgba(0,0,0,0.08)`

### Sidebar Navigation
- Vertical container on left with 256px width
- Main content container flex-1
- Use your design system's neutral color for inactive items
- Use your design system's primary color for active states

### Form Grid
- Container with spacing from your design system's scale
- Form fields stacked vertically
- Labels: 14px medium DM Sans, text primary `#0A0A0Aff`
- Inputs: 6px radius, `#E8E8ECff` borders, focus uses primary indigo

### Modal Overlay
- Root container with semi-transparent backdrop (`rgba(0,0,0,0.5)`)
- Centered white modal (`#FFFFFFff`) with `#E8E8ECff` border
- 12px radius
- Shadow: `0 8px 30px rgba(0,0,0,0.08)`

---

## Validation Checklist

Before saving a new page:

- [ ] All component IDs are unique within the page
- [ ] `parent` field matches an existing component ID
- [ ] `nodes` array contains only IDs defined in `components`
- [ ] `linkedNodes` IDs exist and have correct parent relationships
- [ ] ROOT container is defined and has `isCanvas: true`
- [ ] All required `type.resolvedName` values are valid component types
- [ ] Props align with component type (no Button-specific props on Text, etc.)
- [ ] No circular parent references
- [ ] File ends with proper JSON formatting (no trailing commas)
