# Passwording.pas Documentation

## Overview
`Passwording.pas` defines the visual authentication credential input form (`TfmPassword`) used to request and validate administrator passwords and lock overrides in the SATRA platform.

## Key Features & Security Hooks
- **Masked Password Field**: Obscures characters during input.
- **Credential Validation**: Validates entered credentials against secure salts and hashes, utilizing functions declared in `Encryption.pas`.
- **Dynamic Styling**: Styled at runtime via `AutoColor` to match the application's central design aesthetics.

## Web Portal Replacement
For modern, web-based authentication:
- **Federated Identity (OIDC)**: Physical password forms are replaced by secure Identity Providers (e.g. Auth0, Microsoft Entra ID) using OpenID Connect and SAML.
- **Multifactor Authentication (MFA)**: Modern sign-in incorporates MFA, biometric authorization (WebAuthn), and OAuth2 flows, ensuring industry-standard security.
