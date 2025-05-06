#!/bin/bash

# Uncomment all locales in /etc/locale.gen using regex
sudo sed -i 's/^#\([a-zA-Z0-9._-]\+\s\+[a-zA-Z0-9._-]\+\)/\1/' /etc/locale.gen

# Generate all locales
sudo locale-gen

# Set default locale (e.g., en_US.UTF-8)
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf

# Verify
echo "Generated locales:"
locale -a