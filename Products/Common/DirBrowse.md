# DirBrowse.pas Documentation

## Overview
`DirBrowse.pas` defines the `TfmDirBrowse` form class, which acts as a customizable folder selection and directory navigation dialog in the SATRA Suite. It allows administrators and users to browse local filesystems and network resources to set CAD models, export folders, and database directories.

## Visual Design & Interaction
- **Directory Tree / Shell Controls**: Integrates shell navigation controls to present recursive directory trees cleanly.
- **Dynamic Theme Matching**: Fully integrates with the global `AutoColor` function (defined in `General.pas`) to skin borders, tree view lines, navigation buttons, and typography according to SATRA's corporate visual themes.
- **Path Selection Return**: Validates folder existence upon selection and returns the resolved absolute directory string.

## Web Portal Replacement
When transitioning directory navigation to modern web platforms:
- **Client-Side File API**: Web applications utilize modern HTML5 File System Access APIs (`showDirectoryPicker`) for direct local directory selection inside the browser.
- **Server-Side File Browsers**: Administrative consoles use secure server-side file explorer components with validated backend routes, preventing unauthorized directory transversal and guaranteeing strict system boundaries.
