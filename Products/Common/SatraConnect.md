# SatraConnect.pas Documentation

## Overview
`SatraConnect.pas` is the database connector module for the SATRA platform. It defines the primary FireDAC connections (`TFDConnectionPlus`) and data tables (such as locking tables) that connect the desktop client application to the underlying Advantage Database Server (ADS) systems (`SUMMS6`, `SUMMS6_L`, `SDATA6`).

## Database Connections
- **`AdsConnectionSumms6` / `AdsConnectionSumms6_L`**: Connects to the main SATRA SUMMS calculation databases.
- **`AdsConnectionSdata6`**: Connects to the standard parameters and shared material default databases.
- **`tblLocks` (`TFDTable`)**: Interacts with the shared database locks table, preventing overlapping edits when multiple workstations attempt concurrent updates.

## Initialization Flow
When the module is created (`DataModuleCreate`), it attempts to establish connection handshakes with the Advantage Server. If a connection fails (e.g. `SDATA6`), the application catches the error and warns the user, helping ensure the platform remains stable before executing transactions.

## Modern Web Porting
In modern multi-tenant cloud architectures:
- **Connection Pools**: Physical connections are managed via backend connection pools (e.g. Prisma Client / PgPool), improving scalability.
- **Database Migrations**: Schema controls migrate to migration tools (like Prisma migrations / Liquibase), providing robust schema evolution.
