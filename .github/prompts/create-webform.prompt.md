---
description: "Create a new Qodly WebForm page from a description, following the qodly-page-builder skill and the Genesis design system."
name: "Create WebForm"
argument-hint: "Describe the page: purpose, fields/components, and layout"
agent: "agent"
---
Create a new Qodly WebForm page based on the user's request: ${input:request:Describe the page (purpose, fields, layout)}.

Follow these steps precisely:

1. **Load conventions**: Read the `qodly-page-builder` skill at [.github/skills/qodly-page-builder/SKILL.md](../skills/qodly-page-builder/SKILL.md) for WebForm JSON structure, component types, composite `linkedNodes`, and the React inline-style rules.
2. **Respect the design system**: Read [.design/genesis.DESIGN.md](../../.design/genesis.DESIGN.md) for colors, typography, spacing, radius, and component patterns. Reuse the CSS variables already defined in [Project/Sources/Shared/shared_css.json](../../Project/Sources/Shared/shared_css.json) (e.g. `var(--primary-color)`, `var(--spacing-md)`, `var(--border-radius-lg)`) instead of hard-coded hex/pixel values. Add new shared classes there only if a style is reused across pages.
3. **Plan the tree**: Sketch the component hierarchy before writing. `ROOT` is the only `Container`; use `StyleBox` for all nested grouping and flex/row layouts. Generate unique 8–12 char alphanumeric IDs.
4. **Build components**: Define each component with `type`, `props`, `parent`, `nodes`, and `linkedNodes`. Wire composites correctly (TextInput → Label+Input, SelectInput → Label+Select, Checkbox → Label+CheckboxInput, Button → Icon). Use the ProseMirror `doc` format for `Text` and include `"custom": { "__t": { "doc": [] } }`.
5. **Style**: Use camelCase React inline styles or Tailwind `className`; never write empty `style` objects or hyphenated CSS keys. Honor design-system rules (one primary button per section, indigo only for interactive elements, 6px radius on inputs/buttons, 12px on cards).
6. **Save**: Write the file to `Project/Sources/WebForms/<PageName>.WebForm`. Use a clear camelCase page name derived from the request.
7. **Validate**: Confirm the JSON is well-formed (parse it), every ID in `nodes`/`linkedNodes` resolves to a defined component, and no `Container` is nested.

Then give the user a brief summary of the page name, layout, and components created.
