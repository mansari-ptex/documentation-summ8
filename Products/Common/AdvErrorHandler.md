# AdvErrorHandler.pas Documentation

## Overview
`AdvErrorHandler.pas` implements specialized exception handling for the Advantage Database Server (ADS) database backend and FireDAC connections within the SATRA platform. When FireDAC queries (`TFDQuery`) or tables (`TFDTablePlus`) encounter locking, syntax, or privilege violations, this unit processes the underlying errors and translates technical database codes into actionable user alerts.

## Architectural Purpose
Database client systems require high reliability. `AdvErrorHandler.pas` prevents database engine crashes and raw SQL exceptions from bubbling up to the user by:
1. Intercepting database connection, statement execution, or transaction exceptions.
2. Parsing Advantage-specific error codes (e.g., locking conflicts, record modifications, read-only dataset rules).
3. Displaying customized, friendly prompts or delegating logging.

## Core Integration
- **FireDAC Client Engine**: Connects directly with components like `TFDConnection`, `TFDTablePlus`, and `TFDQuery` to catch `EDataBaseError` and Advantage-specific database exception instances.
- **`General.pas`**: Works in tandem with locking functions (e.g., `LockSingle`, `LockGroupIncStatusBar`) to identify whether an update failed due to lock-contention (ADS error status) or database read-only constraints.

## Modernization Strategy
For backend services migrating away from Delphi and toward modern web architectures (e.g., SQL Server + Prisma / Node.js):
- **Middleware Error Handlers**: The exception-mapping logic translates directly into standard HTTP error mapping. For instance, record locking conflicts or transactional rollbacks are mapped to `409 Conflict` REST responses or standardized Zod validation failures.
