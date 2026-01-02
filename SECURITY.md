# Security Policy

## Supported Versions
The **Linux Auto-Installation Scripts** repository supports the current versions of the supported Linux distributions (Arch Linux, Debian/Ubuntu, Fedora/Red Hat, Void Linux). Security updates will be applied to scripts and documentation as needed.

## Reporting a Vulnerability
If you discover a security vulnerability in any of the scripts or the repository, please report it responsibly:

1. **Do Not Open a Public Issue**: To protect users, avoid disclosing vulnerabilities publicly until they are resolved.
2. **Contact the Maintainers**:
   - Email: [Insert contact email, e.g., security@example.com]
   - Include a detailed description of the vulnerability, steps to reproduce, and potential impact.
3. **Response Time**:
   - We will acknowledge your report within 48 hours.
   - We aim to resolve and release fixes within 7 days for critical issues.
4. **Disclosure**:
   - Once resolved, we will credit you (if desired) in the release notes unless you prefer to remain anonymous.

## Best Practices
- Review scripts before execution, especially on production systems.
- Ensure your system's package repositories are up-to-date before running scripts.
- Avoid running scripts from untrusted sources.
- Follow the guidelines in [CONTRIBUTING.md](CONTRIBUTING.md) for secure scripting practices.
- Be cautious with scripts that require root privileges.

## Security Considerations for Scripts
- Scripts may install software and modify system configurations.
- Some scripts require root/sudo access for package installation.
- Always backup important data before running automation scripts.
- Test scripts in isolated environments before production use.

Thank you for helping keep **Linux Auto-Installation Scripts** secure!