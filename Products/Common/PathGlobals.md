# PathGlobals.pas Documentation

## Overview
`PathGlobals.pas` defines the global constants, coordinate records, pattern collection arrays, and system state variables for CAD pattern boundary digitizing and spline smoothing in the SATRA platform.

## Key Constants & Types
- **`SmoothPointsPerPoint`** = `10`: Defines the interpolation subdivision density for the cubic spline engine in `PathGeometry.pas`.
- **`MaxRawPoints`** = `501`: Sets the buffer size for raw digitized vertices.
- **`MaxSmoothPoints`** = `5001`: Sets the maximum size for the generated smooth point array.
- **`TPathPointCharacteristic`**: An enumeration (`Normal`, `Corner`, `NewPath`) that classifies coordinates for tool actions.
- **`TPathPoint`**: A record that holds coordinates, path characteristics, features, and tool settings.
- **`TSummsPatternCollection`**: Stores collection name, length, and coordinate arrays for multi-pattern pieces.

## Architectural Context
`PathGlobals.pas` serves as the shared data contract for all CAD modules, ensuring consistency between coordinates captured by digitizing tablets and coordinates rendered or exported to files.

## Modernization Mapping
In modern web applications:
- **TypeScript Interfaces**: These structures map directly to TypeScript definitions (e.g. `interface PathPoint { x: number; y: number; characteristic: PathPointCharacteristic; ... }`).
- **State Management**: Centralized arrays (like `RawPts`) map to state management solutions (e.g. Redux / Zustand stores) in modern web-based CAD tools.
