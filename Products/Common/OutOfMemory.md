# OutOfMemory.pas Documentation

## Overview
`OutOfMemory.pas` defines the fallback error dialog (`TfmOutOfMemory`) displayed to the user when the application encounters system resource exhaustion or heap allocation failures.

## Key Behaviors
- **Critical Recovery Alert**: Warns the user of low system memory and guides them to save open projects (if possible) and restart the application safely.
- **Fail-Safe Rendering**: Designed to be lightweight and simple, minimizing heap allocations when system memory is nearly exhausted.
- **Visual Formatting**: Adheres to the central styling pattern, utilizing `AutoColor` to skin the warning borders and buttons cleanly.

## Web Modernization Parallel
In modern web applications:
- **Global Error Boundaries**: Managed via React/Next.js global Error Boundaries or custom window event listeners (`unhandledrejection`), presenting graceful fallback pages.
- **Memory Profiling**: Handled by garbage collectors and browser environment monitoring tools, logging memory leaks automatically to tracking services (e.g. Sentry / LogRocket) for developers to analyze.
