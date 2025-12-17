# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please report it responsibly.

### How to Report

1. **Email**: Send details to security@hyperpolymath.org
2. **Encryption**: Use our [PGP key](https://hyperpolymath.org/gpg/security.asc) for sensitive reports
3. **Do NOT** create public GitHub issues for security vulnerabilities

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 7 days
- **Resolution Timeline**: Depends on severity
  - Critical: 24-48 hours
  - High: 7 days
  - Medium: 30 days
  - Low: 90 days

### Security Measures

This project implements the following security controls:

- **No weak cryptography**: MD5/SHA1 blocked for security contexts (SHA256+ required)
- **HTTPS only**: No HTTP URLs in production code
- **No hardcoded secrets**: All secrets must use environment variables
- **SHA-pinned actions**: All GitHub Actions use SHA-pinned versions
- **OSSF Scorecard**: Supply chain security monitoring
- **CodeQL**: Static Application Security Testing (SAST)
- **Dependabot**: Automated dependency updates

### Disclosure Policy

- We follow coordinated disclosure
- Credit will be given to reporters (unless anonymity is requested)
- Public disclosure after fix is released (minimum 90 days for complex issues)

## Security.txt

See [.well-known/security.txt](.well-known/security.txt) for RFC 9116 compliant security contact information.
