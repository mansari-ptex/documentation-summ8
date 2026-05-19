# CutUtils2_Summs7.pas Documentation

## Overview
`CutUtils2_Summs7.pas` serves as the secondary data helper module for the Summs7 footwear cutting operations suite. It provides lower-level mathematical logic, string formatters, and secondary database queries that support the primary time-compilation and standard-minute (SM) routines located in `Cututils_Summs7.pas`.

## Key Roles & Operations
- **Query Formatting & Sanitization**: Includes internal SQL string helper methods (like query-safe escapes) to sanitize arguments dynamically fed to FireDAC databases.
- **Supplemental Formulas**: Implements fractional conversions, batch scaling, and layout geometry mathematics that calculate synthetic roll yields and leather scrap wastage percentages.
- **Data Serialization**: Handles reading/writing temporary data states to support multi-size operations during batch runs.

## Architectural Architecture
Separating these routines into a secondary helper file keeps `Cututils_Summs7.pas` focused entirely on primary time-study elements and core algorithms, ensuring clear modularity and maintaining code readability.

## Modernization Strategy
During migration to a modern Node.js/TypeScript architecture:
- **Helpers Utility Module**: These routines map directly to pure utility functions (e.g. `/utils/mathHelpers.ts` or `/utils/stringEscaper.ts`).
- **Prisma SQL Builders**: Query building logic translates to type-safe Prisma ORM queries or raw parameterized SQL queries, eliminating SQL injection risks natively.
