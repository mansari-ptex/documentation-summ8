# AccessDenied.pas Documentation

## Overview
`AccessDenied.pas` defines the `TfmAccessDenied` form class, which acts as a standard access control dialog in the SATRA Suite. It displays an access-denied message to the user when they try to perform an operation or modify a resource for which they do not have appropriate permissions (e.g. attempting to lock database records when they lack sufficient rights).

## Visual Customization & Form Structure
- **TLabel (`lblMessage`)**: Dynamically updated from database modules or security guards using the global `ADMessage(TheMessage: string)` procedure.
- **TButton (`btnOk`)**: Closes the dialog.
- **AutoColor Integration**: The form relies on the dynamic RTTI-based coloring engine (`AutoColor`) located in the global `General.pas` unit to dynamically skin the dialog background and typography to match the enterprise color scheme.

## Key Routines & API Interactions
The form's dynamic display is managed through the global routine `ADMessage` inside `General.pas`:
```pascal
procedure ADMessage(TheMessage: string);
begin
  fmAccessDenied.lblMessage.caption := TheMessage + '.';
  fmAccessDenied.showModal;
end;
```
This centralizes access validation error UI notifications across the workspace, replacing brittle system message dialogs with a styled SATRA-branded window.

## Architectural Recommendations
- **Modernization**: For web-migrated modules (e.g., Node.js / React portal), this visual alert maps to a standard `403 Forbidden` response handled by an API middleware processor, showing a premium themed toast message rather than modal Windows dialogs.
