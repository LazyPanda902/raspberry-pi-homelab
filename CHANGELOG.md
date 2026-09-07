# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Read-only Raspberry Pi and Docker audit with a sanitized public mode
- Output sanitizer for common infrastructure secrets and identifiers
- Dry-run-first temporary-file cleanup with protected-path checks
- Bats coverage for audit, sanitization, and cleanup behavior
- CI checks for Bash, ShellCheck, Bats, Compose, and Markdown links
- Verified architecture, operations, security, troubleshooting, usage, and sample-output documentation
- MIT license, contribution guidance, security policy, and privacy statement

### Changed

- Replaced generic service claims with the currently verified inventory and exposure classifications
- Reworked backup documentation to distinguish procedure from tested recovery evidence

### Removed

- Unverified media-stack claims and the unsafe fixed-path cleanup example
