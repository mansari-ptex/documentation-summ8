# CmnVars.pas Documentation

## Overview
`CmnVars.pas` acts as the primary global state and environment configuration repository for the SATRA application suite. It declares critical runtime variables, system parameters, directory paths, and database connection settings shared across all calculation modules, CAD geometries, and data modules.

## Key Declarations & Global States
- **User Settings & Permissions**: Tracks the current system username (`SystemUserName`), master passwords (`MasterPassword`), and security permissions.
- **Directory Paths**: Resolves absolute folder locations for CAD models, local database tables, output reports, and export destinations.
- **Environment Flags**: Keeps track of active modules (e.g. `TIMELINE` compiler directives) and system-wide modes (e.g. database locks, read-only mode).
- **Global Connections**: Hosts system connections used by FireDAC clients and data modules (`FDConnection` array).

## Architectural Value
By centralizing variable definitions, `CmnVars.pas` prevents duplication and namespace clutter across the Delphi suite. It serves as a unified configuration layer, allowing modules like `General.pas` and `PathGeometry.pas` to resolve shared states without tight coupling.

## Modernization Mapping
In modern TypeScript-based web architectures:
- **Environment Configurations**: Translates directly to a combination of central environment configurations (`.env`), React contexts, or state management stores (e.g., Redux, Zustand) for UI-specific user/session state.
- **Constants Modules**: Centralized into shared constants modules (`/config` or `/constants`) in a monorepo setup to maintain single-source-of-truth architectures.
