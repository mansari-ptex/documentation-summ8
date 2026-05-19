# Encryption.pas Documentation

## Overview
`Encryption.pas` implements specialized cryptographic operations, password hashing routines, and data encryption algorithms for the SATRA platform. It secures local configuration files, system credentials, and transaction keys.

## Core Capabilities
- **Symmetric Encryption**: Encrypts and decrypts sensitive file blocks, system credentials, and connection configs using pre-shared internal keys.
- **Password Hashing**: Computes digests of passwords for secure storage and comparison in database tables (e.g. `General.pas` user verifications).
- **String Hashing**: Encodes text blocks and generates checksums to verify database record integrity.

## Web Portal Replacement
For modern, industry-standard web services:
- **Standard Hashing**: Proprietary hashing is replaced by standard hashing packages like `bcrypt` or `argon2` for password storage.
- **Node.js Crypto API**: Symmetric operations utilize built-in, vetted packages (e.g., Node's `crypto` module with `aes-256-gcm` or standard TLS encryptions), securing data in transit and at rest.
