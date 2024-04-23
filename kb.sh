#!/bin/bash

project_root=$(grep -oP "(?<=alias kb_path=')[^']+" ~/.bashrc)

if [ -d "$project_root" ]; then
  cd "$project_root" || { echo "Failed to change directory to $project_root"; return 1; }
fi

build() {
  cd "$project_root" || { echo "Failed to change directory to $project_root"; return 1; }

  docker-compose build
}

start() {
  rm -f backend/tmp/pids/server.pid
  docker-compose down
  docker-compose up
}

console() {
  cd "$project_root" || { echo "Failed to change directory to $project_root"; return 1; }

  export $(grep -v '^#' .env | xargs)
  docker exec -it $PROJECT_NAME-backend bash
}

help() {
    echo "Usage: {build|start|console}"
    echo "    build: Build the project using docker-compose"
    echo "    start: Start the project by cleaning up and bringing up docker containers"
    echo "    console: Enter the backend container's console"
}

if [ $# -eq 0 ]; then
    help
    exit 1
fi

case "$1" in
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
