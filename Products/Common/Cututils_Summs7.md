# Cututils_Summs7.pas Documentation

## Overview
`Cututils_Summs7.pas` is a central data module that handles time studies, element assessments, and query compiling for standard footwear pattern cutting operations using the Summs7 database schema. It compiles and totals elements for both selective leather cutting and layered synthetic cutting.

## Core Features & Routines
- **`AddCElement`**: Tracks and registers operational elements, dynamically constructing conditional SQL queries (`CASE WHEN...`) to update element frequencies and total times on active datasets (`Elements4CuttingValues`).
- **`Answers2LeaElements`**: Evaluates variables like allowed area, interlock percentages, grade difficulty, and tool types to estimate times for leather setups, hide replenishment, knife placement, inspections, punch extractions, straightening, and packaging.
- **`Answers2SynElements`**: Estimates synthetic cutting operations, accounting for clip/gantry roll setups, layered feed systems, layups from rolls/sheets, material realignment, waste chopping, double strikes, and press head cycles.
- **`Value_ElementsAndTotals` & `Values_Total_asSms`**: Totals compiled operations times, adjusting for allowances, and converts raw timings into Standard Minutes (SMs).

## Comparison with Summs8
While Summs8 has refactored databases and upgraded structures, `Cututils_Summs7.pas` maintains backward-compatibility with older Summs7 schemas. It uses older structures but follows the same logical flow as the Summs8 equivalent.

## Modernization Blueprint
- **TypeScript Port**: These algorithmic estimation pipelines translate into pure TypeScript controller actions (e.g. `/controllers/cuttingCalculator.ts`).
- **Prisma Integration**: Prisma relational models replace direct FireDAC client tables, optimizing query joins and performance.
