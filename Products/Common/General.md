# General.pas Documentation

## Overview
`General.pas` is the primary utility and helper module for the SATRA platform. It centralizes dynamic UI theme management, FireDAC connection setups, multi-level record locking, standard formatting, and database transaction tracking.

## Core Features & Routines
- **`OurColor(col: TColor)`**: Maps standard Windows UI colors (such as `clBtnFace`, `clWindow`) to SATRA enterprise brand colors (`clMain`, `clBack`, `clEditing`, `clWarningRed`).
- **`AutoColor(Form: TForm)`**: Iterates recursively through all the child controls of a form using Delphi RTTI (`TypInfo`), replacing system styles with themed equivalents.
- **`LockSingle` & `LockGroupIncStatusBar`**: Manages transactional record locks for operations (e.g. knives, materials, styles), prompting users with lock status details via `fmLockedDialog`.
- **`GetTransactionNo`**: Retrieves sequential database transaction IDs using row identifiers.
- **`ItemGone`**: Refreshes tables and verifies record existence, displaying alerts if items (e.g., styles, suppliers) were deleted by another user.
- **`SortOrder`**: Handles table sorting dynamically by updating sort column indicators and SQL strings.

## Strategic Role
`General.pas` acts as the operational core of the legacy system, providing shared utilities that keep forms lightweight and consistent.

## Web Modernization Parallel
When porting these operations to a web application:
- **Central CSS Themes**: Visual mapping is handled by central CSS variables, HSL Tailwind custom palettes, or UI theme providers.
- **Transactional APIs**: Multi-user record locks translate to server-side pessimistic locks (such as Postgres `SELECT ... FOR UPDATE`) or optimistic concurrency controls (Prisma transaction tokens).
