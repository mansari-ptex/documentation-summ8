# LockedDialog.pas Documentation

## Overview
`LockedDialog.pas` defines the `TfmLockedDialog` form class, which acts as the unified concurrency lock notification window in the SATRA Suite. When a user tries to modify a style, part, material, or knife set that is currently locked by another workstation, this form shows who holds the lock, what computer they are using, and their network location.

## Key Properties & Behaviors
- **Lock Detail Panel**: Displays variables provided by the `LocksLockedBy` database queries:
  - **Locked Item**: The specific style, part, or material range that is occupied.
  - **Lock Owner**: The system username of the lock holder.
  - **Computer Name / Network Address**: Network tracking details.
- **Dynamic Skinning**: Runs the recursive RTTI `AutoColor` process on show to align panel borders, button shadows, and labels with the active system theme.

## Modern Concurrency Modernization
For web-based applications:
- **WebSocket Concurrency Alerts**: Web architectures replace locking dialogs with real-time WebSocket messaging (using Socket.io or SignalR), notifying authors immediately when another user enters an editing screen (similar to Figma or Google Docs co-authoring).
- **Optimistic Locks**: Employs Prisma/SQL Server optimistic locking with transaction tokens to safely resolve concurrent save attempts without blocking reads.
