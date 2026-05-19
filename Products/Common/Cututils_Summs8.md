# Cututils_Summs8.pas Documentation

## Overview
`Cututils_Summs8.pas` is a core data module responsible for compiling operations times, operational elements, and Standard Minutes (SMs) for footwear pattern cutting operations using the Summs8 database schema. It supports estimations for both leather (hide) cutting and synthetic material (roll/sheet) cutting.

## Primary Routines & Mathematical Logic
- **`AddCElement`**: Formats operation elements and constructs conditional batch SQL inserts/updates. It registers elements (like setup, replenishment, positioning) to tables such as `Elements4Operations` or `CuttingElements`.
- **`Answers2LeaElements`**: Evaluates variables like allowed area, interlock percentages, grade difficulty, and tool types to estimate times for leather setups, hide replenishment, knife placement, inspections, punch extractions, straightening, and packaging.
- **`Answers2SynElements`**: Estimates synthetic cutting operations, accounting for clip/gantry roll setups, layered feed systems, layups from rolls/sheets, material realignment, waste chopping, double strikes, and press head cycles.
- **`Operations_Total_asSms`**: Consolidates operation timings, factors in rest/contingency allowances, and computes final Standard Minutes (SMs).

## Key Constants
- **`INCHES_TO_CMS`** = `2.54`
- **`CMS_TO_INCHES`** = `0.393700787`
- **`SQFT_TO_SQINCHES`** = `144`
- **`SQDC_TO_SQFT`** = `0.1076`
- **`METRES_TO_CMS`** = `100`
- **`INCHES_TO_FEET`** = `0.083333333`

## Modern Web Porting
When migrating this calculation service to a Node.js web API:
- **Modular Business Logic**: The calculations map directly to an analytical service layer (`/services/cuttingCalculationService.ts`).
- **Standardized DB Controllers**: Replaces raw SQL updates and FireDAC connections with automated ORM updates (like Prisma), wrapping database alterations in secure database transactions.
