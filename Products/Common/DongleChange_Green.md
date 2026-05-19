# DongleChange_Green.pas Documentation

## Overview
`DongleChange_Green.pas` defines the visual dialog form (`TfmDongleChange`) that allows administrators to update security credentials, activation limits, and license profiles stored within the local green hardware protection dongle.

## Key Mechanics & Security Flows
- **Credential Forms**: Captures security update keys, module activations, or user capacity increments.
- **Hardware Integration**: Communicates with the hardware dongle driver APIs (using routines declared in `Dongle_Green.pas`) to securely write encrypted configuration bytes to the physical token's memory.
- **Visual Formatting**: Calls the shared `AutoColor` procedure to style inputs, progress status bars, and confirmation buttons to ensure design consistency.

## Cloud-First Modernization
For modern, cloud-deployed systems:
- **Cloud Licensing Services**: Physical hardware security dongles are replaced by SaaS licensing providers (e.g., Auth0, Keycloak, or custom license servers).
- **Asymmetric Encryption**: Entitlements are validated via cryptographically signed JSON Web Tokens (JWT) or online activation tickets, eliminating physical dongle dependencies entirely and enabling flexible SaaS subscriptions.
