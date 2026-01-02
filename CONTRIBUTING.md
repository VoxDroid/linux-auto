# Contributing to Linux Auto-Installation Scripts

Thank you for your interest in contributing to the **Linux Auto-Installation Scripts** repository! We welcome contributions from the community to improve scripts, add new installation automation, enhance documentation, and address issues.

## How to Contribute

### 1. Reporting Issues
- Check the [issue tracker](https://github.com/VoxDroid/linux-auto/issues) to ensure the issue hasn't been reported.
- Use the appropriate issue template (bug report, feature request, or documentation improvement) in `.github/ISSUE_TEMPLATE/`.
- Provide clear details, including steps to reproduce, expected behavior, and actual behavior.

### 2. Submitting Pull Requests
- Fork the repository and create a new branch for your changes (`git checkout -b feature/your-feature-name`).
- Follow the structure of existing scripts:
  - Place new scripts in the appropriate distribution folder under `shell/auto_installers/`.
  - Ensure scripts include proper error handling, logging, and comments.
- Update relevant README files to document new scripts.
- Test your scripts on the target Linux distribution(s).
- Submit a pull request using the [PULL_REQUEST_TEMPLATE.md](https://github.com/VoxDroid/linux-auto/blob/main/.github/PULL_REQUEST_TEMPLATE.md).
- Ensure your scripts follow shell scripting best practices.

### 3. Adding New Scripts
- Scripts should automate package installation and configuration for specific tools or software.
- Include support for multiple distributions where possible.
- Add appropriate error checking and user feedback.
- Place scripts in the correct distribution directory or create new directories if adding support for new distributions.

### 4. Code Style
- Use Bash for shell scripts with proper shebang (`#!/bin/bash`).
- Include comments explaining complex operations.
- Use consistent indentation and formatting.
- Ensure scripts are executable and handle permissions appropriately.
- Include dependencies and prerequisites in script comments or documentation.

### 5. Testing
- Test scripts on clean installations of target distributions.
- Verify package installations work correctly.
- Check for edge cases and error conditions.
- Ensure scripts are idempotent (safe to run multiple times).

### 6. Documentation
- Update distribution-specific README files when adding new scripts.
- Include inline comments in scripts for complex logic.
- Provide usage examples and prerequisites in documentation.

## Script Development Guidelines

### Best Practices
- Use package managers appropriate for each distribution (pacman, apt, dnf, xbps).
- Include error handling with appropriate exit codes.
- Provide user feedback during long operations.
- Avoid hardcoding paths; use variables where possible.
- Check for root/sudo privileges when required.

### Naming Conventions
- Scripts should be named `install_<purpose>.sh` (e.g., `install_devtools.sh`).
- Use lowercase with underscores for readability.
- Keep names descriptive but concise.

### Distribution Support
- Test scripts on the intended distributions.
- Handle distribution-specific differences (package names, commands).
- Document any distribution limitations.

## Getting Help
If you need assistance, refer to [SUPPORT.md](SUPPORT.md) or open an issue with the "question" label.

## Code of Conduct
All contributors must adhere to our [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

Thank you for helping make **Linux Auto-Installation Scripts** better!