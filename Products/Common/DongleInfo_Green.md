# DongleInfo_Green.pas Documentation

## Overview
`DongleInfo_Green.pas` defines the visual info-panel form (`TfmDongleInfo`) that displays details about the system's local green hardware protection dongle, such as active software modules, expiry dates, batch limits, and serial numbers.

## Key Interfaces
- **License Detail Panels**: Displays active modules (e.g. grading modules, costing utilities, nested markers) retrieved from the hardware key.
- **Hardware Integration**: Reads license blocks via secure dongle APIs (defined in `Dongle_Green.pas`), displaying properties like serial numbers and expiration dates.
- **Dynamic Skinning**: Inherits corporate theme customization via `AutoColor` to paint dialog backgrounds, info tables, and labels consistently.

## Cloud-First Modernization
For cloud-first deployments:
- **Licensing Dashboards**: Licensing pages are replaced by React-based account portals or dashboard settings pages displaying SaaS subscriptions, user seats, active features, and billing tiers.
- **Microservices API**: Active user scopes are verified via OAuth2 scopes or database-driven entitlements, simplifying administration and removing hardware dependencies.
