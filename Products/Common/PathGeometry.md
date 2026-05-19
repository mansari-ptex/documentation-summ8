# PathGeometry.pas Documentation

## Overview
`PathGeometry.pas` is a core mathematical module within the SATRA platform. It translates discrete coordinates from digitizer inputs into smooth cubic splines (`cspline`), calculates total boundary lengths and interior areas, and exports structured CAD data files (`.xy` and `.pth`) used by footwear cutting machines.

## Primary Algorithms & Routines
- **`AnalyseLine`**: Coordinates the entire path calculation, splitting digitized coordinates into continuous geometric segments and smoothing closed patterns.
- **`cspline`**: Fits a smooth parametric cubic spline to the input vertices, matching tangents across smooth nodes.
- **`AnalyseCurve`**: Standardizes coordinate spacing to 1mm intervals, computes curvature radius (`GetRadius`) at each step, and maps segments to standard CAD tool categories (e.g. radii ranging from 5mm to 110mm / straight line).
- **`GetRadius`**: Calculates the exact curvature radius using three sequential coordinates.
- **`CalculateArea`**: Computes the absolute interior area enclosed by a closed pattern using vector polygon integration.
- **`Analyse2Points`**: Handles straight lines between sharp corners.

## Key Exports
- **`.xy` File**: A text file containing sequential Cartesian coordinates of the pattern's boundary path.
- **`.pth` File**: A structured file mapping tool actions, path types (outer boundary, slot, punch), and curvature categories for cutting machines.

## Web Portal Porting
For modern cloud-based CAD platforms:
- **WebGL / Canvas rendering**: Geometry calculations and spline paths are rendered in the browser using three.js or canvas libraries.
- **TypeScript Calculation Engine**: Porting spline calculations to a server-side engine allows real-time SVG parsing and grading estimations in web-based workflows.
