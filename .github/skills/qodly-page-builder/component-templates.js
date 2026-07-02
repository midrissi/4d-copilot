// Qodly Page Builder - Component Templates & Utilities
// Copy and adapt these templates when creating WebForm pages

/**
 * UTILITY: Generate random component ID
 * Usage: const id = generateComponentId()
 * Returns: 12-character alphanumeric string
 */
function generateComponentId() {
  return Math.random().toString(36).substr(2, 12);
}

/**
 * COMPONENT TEMPLATES
 * Copy and paste these into your WebForm JSON, replacing IDs as needed
 */

// ============================================================================
// CONTAINER (Page Root)
// ============================================================================
const ContainerTemplate = {
  type: { resolvedName: "Container" },
  isCanvas: true,
  props: {
    className: "bg-white w-full px-6",
    classNames: [],
    events: [],
    airyMode: false,
  },
  displayName: "Container",
  custom: {},
  parent: "ROOT", // or set to another container ID for nested layouts
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// TEXT
// ============================================================================
const TextTemplate = {
  type: { resolvedName: "Text" },
  isCanvas: false,
  props: {
    text: "Your text here",
    classNames: [],
    events: [],
    datasource: "",
  },
  displayName: "Text",
  custom: { __t: { doc: [] } },
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// BUTTON + ICON (Composite)
// ============================================================================
const ButtonTemplate = {
  buttonId: "btn_" + generateComponentId(),
  iconId: "icon_" + generateComponentId(),
};

const ButtonWithIcon = (buttonId, iconId) => ({
  [buttonId]: {
    type: { resolvedName: "Button" },
    isCanvas: false,
    props: {
      text: "Click Me",
      classNames: [],
      events: [],
      iconPosition: "left",
      style: { backgroundColor: "#e73351ff" },
    },
    displayName: "Button",
    custom: {},
    parent: "ROOT",
    hidden: false,
    nodes: [],
    linkedNodes: { icon: iconId },
  },
  [iconId]: {
    type: { resolvedName: "Icon" },
    isCanvas: false,
    props: {
      classNames: [],
      events: [],
      icon: "fa-regular fa-star",
    },
    displayName: "Icon",
    custom: {},
    parent: buttonId,
    hidden: false,
    nodes: [],
    linkedNodes: {},
  },
});

// ============================================================================
// TEXT INPUT (Composite: TextInput + Label + Input)
// ============================================================================
const TextInputWithLabel = (textInputId, labelId, inputId) => ({
  [textInputId]: {
    type: { resolvedName: "TextInput" },
    isCanvas: false,
    props: {
      events: [],
      iterableChild: true,
      placeholder: "Enter text",
      label: "Label",
      labelPosition: "left",
      style: { marginBottom: "10px" },
    },
    displayName: "Text Input",
    custom: {},
    parent: "ROOT",
    hidden: false,
    nodes: [],
    linkedNodes: { label: labelId, input: inputId },
  },
  [labelId]: {
    type: { resolvedName: "Label" },
    isCanvas: false,
    props: {
      text: "Label",
      classNames: [],
      events: [],
      moveable: false,
      deletable: true,
    },
    displayName: "Label",
    custom: {},
    parent: textInputId,
    hidden: false,
    nodes: [],
    linkedNodes: {},
  },
  [inputId]: {
    type: { resolvedName: "Input" },
    isCanvas: false,
    props: {
      events: [],
      deletable: false,
      className: "w-full bg-transparent",
      type: "text",
      moveable: false,
      placeholder: "Enter text",
      revealPassword: true,
      style: {
        borderRadius: "5px",
        borderWidth: "1px",
        borderColor: "#3b82f6ff",
      },
    },
    displayName: "Input",
    custom: {},
    parent: textInputId,
    hidden: false,
    nodes: [],
    linkedNodes: {},
  },
});

// ============================================================================
// IMAGE
// ============================================================================
const ImageTemplate = {
  type: { resolvedName: "Image" },
  isCanvas: false,
  props: {
    classNames: [],
    events: [],
    style: {},
    altText: "Image description",
    imgSrc: "/$shared/assets/images/photo.avif",
    defaultImgSrc: "/$shared/assets/images/photo.avif",
  },
  displayName: "Image",
  custom: {},
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// FILE UPLOAD + ICON
// ============================================================================
const FileUploadWithIcon = (fileUploadId, iconId) => ({
  [fileUploadId]: {
    type: { resolvedName: "FileUpload" },
    isCanvas: false,
    props: {
      classNames: [],
      events: [],
      text: "Upload Binary",
      iconPosition: "left",
      style: { borderStyle: "dashed" },
    },
    displayName: "File Upload",
    custom: {},
    parent: "ROOT",
    hidden: false,
    nodes: [],
    linkedNodes: { icon: iconId },
  },
  [iconId]: {
    type: { resolvedName: "Icon" },
    isCanvas: false,
    props: {
      classNames: [],
      events: [],
      icon: "fa-regular fa-star",
    },
    displayName: "Icon",
    custom: {},
    parent: fileUploadId,
    hidden: false,
    nodes: [],
    linkedNodes: {},
  },
});

// ============================================================================
// RADIO (Single or Multi)
// ============================================================================
const RadioTemplate = {
  type: { resolvedName: "Radio" },
  isCanvas: false,
  props: {
    classNames: [],
    events: [],
    defaultValue: "option1",
    mode: "single", // "single" or "multi"
    type: "tabs", // "tabs" or "buttons"
    options: [
      { id: "opt1", label: "Option 1", value: "option1" },
      { id: "opt2", label: "Option 2", value: "option2" },
      { id: "opt3", label: "Option 3", value: "option3" },
    ],
  },
  displayName: "Radio",
  custom: {},
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// CHECKBOX
// ============================================================================
const CheckboxTemplate = {
  type: { resolvedName: "Checkbox" },
  isCanvas: false,
  props: {
    classNames: [],
    events: [],
    defaultValue: ["option1"],
    type: "checkbox", // or "toggle"
    options: [
      { id: "opt1", label: "Option 1", value: "option1" },
      { id: "opt2", label: "Option 2", value: "option2" },
      { id: "opt3", label: "Option 3", value: "option3" },
    ],
  },
  displayName: "Checkbox",
  custom: {},
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// SELECT (Dropdown)
// ============================================================================
const SelectTemplate = {
  type: { resolvedName: "Select" },
  isCanvas: false,
  props: {
    classNames: [],
    events: [],
    defaultValue: "option1",
    placeholder: "Select an option",
    label: "Choose",
    options: [
      { id: "opt1", label: "Option 1", value: "option1" },
      { id: "opt2", label: "Option 2", value: "option2" },
      { id: "opt3", label: "Option 3", value: "option3" },
    ],
  },
  displayName: "Select",
  custom: {},
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// ICON
// ============================================================================
const IconTemplate = {
  type: { resolvedName: "Icon" },
  isCanvas: false,
  props: {
    classNames: [],
    events: [],
    icon: "fa-regular fa-star",
  },
  displayName: "Icon",
  custom: {},
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// TABLE
// ============================================================================
const TableTemplate = {
  type: { resolvedName: "Table" },
  isCanvas: false,
  props: {
    classNames: [],
    events: [],
    datasource: "",
    columns: [
      { id: "col1", name: "Column 1", sortable: true },
      { id: "col2", name: "Column 2", sortable: true },
      { id: "col3", name: "Column 3", sortable: false },
    ],
    rowHeight: 50,
    style: {},
  },
  displayName: "Table",
  custom: {},
  parent: "ROOT",
  hidden: false,
  nodes: [],
  linkedNodes: {},
};

// ============================================================================
// COMMON FONTAWESOME ICONS
// ============================================================================
const Icons = {
  star: "fa-regular fa-star",
  heart: "fa-regular fa-heart",
  trash: "fa-regular fa-trash",
  edit: "fa-regular fa-pen",
  save: "fa-regular fa-save",
  download: "fa-regular fa-download",
  upload: "fa-regular fa-upload",
  search: "fa-regular fa-magnifying-glass",
  plus: "fa-regular fa-plus",
  minus: "fa-regular fa-minus",
  check: "fa-regular fa-check",
  x: "fa-regular fa-x",
  arrow_right: "fa-regular fa-arrow-right",
  arrow_left: "fa-regular fa-arrow-left",
  home: "fa-regular fa-house",
  user: "fa-regular fa-user",
  settings: "fa-regular fa-gear",
  bell: "fa-regular fa-bell",
  lock: "fa-regular fa-lock",
  unlock: "fa-regular fa-unlock",
};

// ============================================================================
// MINIMAL PAGE SKELETON
// ============================================================================
const MinimalPageTemplate = {
  metadata: {
    v: "1.0",
    datasources: [],
    styles: [],
    currentState: "root",
  },
  components: {
    ROOT: {
      type: { resolvedName: "Container" },
      isCanvas: true,
      props: {
        className: "bg-white w-full px-6",
        classNames: [],
        events: [],
        airyMode: false,
      },
      displayName: "Page",
      custom: {},
      parent: "",
      hidden: false,
      nodes: [], // Add component IDs here
      linkedNodes: {},
    },
    // Add your components here
  },
};
