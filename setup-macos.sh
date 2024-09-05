#!/bin/bash

USERNAME=$(whoami)

install_precommit() {
    PROJECT_NAME=$(awk -F'"' '/^PROJECT_NAME/ {print $2}' .env)
    sed -i '' "s/PROJECT_NAME=\".*\"/PROJECT_NAME=\"$PROJECT_NAME\"/g" .dev/pre-commit
    cp .dev/pre-commit .git/hooks/pre-commit
}

set_aliases() {
    echo "Choose your shell profile to update:"
    echo "1) .bashrc"
    echo "2) .zshrc"
    read -p "Enter 1 or 2: " choice

    case "$choice" in
        1)
            PROFILE_FILE="/Users/$USERNAME/.bashrc"
            ;;
        2)
            PROFILE_FILE="/Users/$USERNAME/.zshrc"
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    sed -i '' "/^alias kb_path=/d" "$PROFILE_FILE"
    echo "alias kb_path='$(pwd)'" >> "$PROFILE_FILE"

    sed -i '' "/^alias kb=/d" "$PROFILE_FILE"
    echo "alias kb='$(pwd)/.dev/kb.sh'" >> "$PROFILE_FILE"
}

install_precommit
set_aliases

echo "Setup complete! Don't forget to restart your terminal to make the changes effective."
