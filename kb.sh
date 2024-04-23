#!/bin/bash

setup() {
    PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
    sed -i "s/PROJECT_NAME=\".*\"/PROJECT_NAME=\"$PROJECT_NAME\"/g" .dev/pre-commit
    cp .dev/pre-commit .git/hooks/pre-commit
}

build() {
    docker-compose build
}

start() {
    rm -f backend/tmp/pids/server.pid
    docker-compose up
}

console() {
    export $(grep -v '^#' .env | xargs)
    docker exec -it $PROJECT_NAME-backend bash
}

rails_console() {
    export $(grep -v '^#' .env | xargs)
    docker exec -it $PROJECT_NAME-backend rails console
}

help() {
    echo "Usage: $0 {setup|build|start|console}"
    echo "    setup: Set up the project by configuring pre-commit hook"
    echo "    build: Build the project using docker-compose"
    echo "    start: Start the project by cleaning up and bringing up docker containers"
    echo "    console: Enter the backend container's console"
}

if [ $# -eq 0 ]; then
    help
    exit 1
fi

case "$1" in
    "setup")
        setup
        ;;
    "build")
        build
        ;;
    "start")
        start
        ;;
    "console")
        console
        ;;
    *)
        echo "Invalid argument: $1"
        help
        exit 1
esac
