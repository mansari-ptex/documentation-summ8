# CutUtils2_Summs8.pas Documentation

## Overview
`CutUtils2_Summs8.pas` is the auxiliary database helper and utility module supporting Summs8 footwear cutting operations. It contains lower-level mathematical logic, SQL query formatting helpers (e.g. query-safe value formatting), and data module helpers that assist the primary element calculations inside `Cututils_Summs8.pas`.

## Key Responsibilities
- **SQL Argument Escaping & Sanitization**: Implements utility routines (such as `QS` - Query Safe string formatting) to safely insert user-provided strings and database values into raw SQL queries without syntax failures.
- **Lower-Level Geometrical Calculations**: Handles area adjustments, roll dimension scaling, and waste factor formulas that evaluate raw material consumption and layout parameters.
- **Batch State Helpers**: Manages temporary calculations and settings to execute multi-size calculations safely.

## Modular Separation
By offloading utility calculations, sanitization helpers, and low-level adjustments to this secondary module, the primary module `Cututils_Summs8.pas` remains highly readable and focused purely on core time study and element estimation algorithms.

## Web Modernization Parallel
When migrating these algorithms to a modern web service:
- **Clean Utility Packages**: These string and math helpers map to pure TypeScript utility functions (e.g. `src/utils/math.ts` or standard sanitize libraries).
- **Prisma Client**: SQL parameter escapes (`QS`) are replaced entirely by automatic parameterized query bindings in modern ORMs (like Prisma), guaranteeing built-in SQL injection security.
