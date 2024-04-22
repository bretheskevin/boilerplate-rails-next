#!/bin/bash

PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
sed -i "s/PROJECT_NAME=\".*\"/PROJECT_NAME=\"$PROJECT_NAME\"/g" .dev/pre-commit

cp .dev/pre-commit .git/hooks/pre-commit
