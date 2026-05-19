# Dongle_Green.pas Documentation

## Overview
`Dongle_Green.pas` is a security driver integration module. It defines low-level functions and external DLL imports to interact with the local physical green USB hardware protection dongle (Sentinel/HASP driver integrations) to enforce licensing bounds.

## Core Security Operations
- **Driver Handshakes**: Handles initial device discovery and driver handshakes upon application startup.
- **Encrypted Memory Reading**: Reads secure, encrypted memory sectors on the USB dongle to parse customer codes, serial numbers, active modules, and usage counts.
- **Cryptographic Validation**: Validates hardware signatures to block software cloning, reverse engineering, and cracked licensing configurations.

## Web-Ready Architecture
In modern SaaS deployments, USB licensing modules are replaced by secure online authentication layers:
- **JWT Entitlements**: Licensing boundaries are enforced using cryptographically signed JSON Web Tokens (JWT) issued by authorization servers (e.g. Auth0 / Keycloak).
- **Entitlement Checks**: Middleware verify user entitlements directly on the backend, removing physical device requirements and simplifying multi-tenant SaaS deployments.
