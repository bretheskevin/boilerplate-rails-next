#!/bin/bash

# look for "PROJECT_NAME="*" in the pre-commit file, and replace it with the project name from .env

PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
sed -i "s/PROJECT_NAME=\".*\"/PROJECT_NAME=\"$PROJECT_NAME\"/g" .dev/pre-commit

cp .dev/pre-commit .git/hooks/pre-commit
