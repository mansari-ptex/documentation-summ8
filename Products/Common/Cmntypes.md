# Cmntypes.pas Documentation

## Overview
`Cmntypes.pas` defines all shared structured data types, enumerations, records, and array specifications used across the SATRA application suite. It serves as the static contract that standardizes data exchanges between database layers, calculation algorithms (such as cutting estimation in `Cututils_Summs8`), and spline interpolations in `PathGeometry.pas`.

## Key Types & Definitions
- **CAD Path and Spline Typology**: Declares definitions for pattern nodes, path markers, and curve points (e.g. `TSplineType`, `TPath` paths, corner coordinates).
- **Database Locks**: Defines enumerated structures to manage locks for database operations (`TWhatToLock`, `TLockedBy` record).
- **Operation Metrics**: Holds performance arrays, calculations, and mathematical records for synthetic/leather cutting simulations.

## Strategic Importance
`Cmntypes.pas` establishes a type-safe contract that prevents format drift between different compilation units. For example, it ensures that when `PathGeometry` processes a geometric vector, the elements and features match the exact structure defined for raw digitizing coordinates.

## Modernization Mapping
In modern TypeScript/Prisma web apps:
- **TypeScript Interfaces / Types**: These records and enumerations translate directly to Zod schemas and TypeScript interfaces (e.g., `export type SplineType = ...` or auto-generated Prisma schemas).
- **Shared Validation Contracts**: Centralizing types allows validation logic (like Zod) to act as the runtime validator, guaranteeing type safety from database query to API response.
