#!/bin/bash

PROJECT_ROOT=$(grep -oP "(?<=alias kb_path=')[^']+" ~/.bashrc)

if [ -d "$PROJECT_ROOT" ]; then
  cd "$PROJECT_ROOT" || { echo "Failed to change directory to $PROJECT_ROOT"; return 1; }
fi

PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
OPTIONS=$(echo "$@" | grep -oP -- '-\w+')

build() {
  docker compose build
}

start() {

  rm -f backend/tmp/pids/server.pid
  docker compose down
  docker compose --project-name $PROJECT_NAME up
}

console() {
  docker exec -it $PROJECT_NAME-backend sh
}

rspec() {
  if [[ $OPTIONS == *"-d"* ]]; then
    docker exec -t $PROJECT_NAME-backend sh -c "RAILS_ENV=test rails db:drop db:create db:migrate"
  fi

  if [[ $1 == -* ]]; then
    shift
  fi

  docker exec -t $PROJECT_NAME-backend sh -c "RAILS_ENV=test rspec --color $1"
}

rubocop() {
  docker exec -t $PROJECT_NAME-backend sh -c "rubocop -A"
}

logs() {
  case "$1" in
    b|back|backend)
      docker logs -f --tail 30 $PROJECT_NAME-backend
      ;;
    f|front|frontend)
      docker logs -f --tail 30 $PROJECT_NAME-frontend
      ;;
    n|nginx)
      docker logs -f --tail 30 $PROJECT_NAME-nginx
      ;;
    *)
      echo "Invalid service name. Use 'backend' or 'frontend'"
      echo "- kb logs backend"
      echo "- kb logs frontend"
      ;;
  esac
}

help() {
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    RESET='\033[0m'

    echo -e "${YELLOW}Usage:${RESET} {${GREEN}build${RESET}|${GREEN}start${RESET}|${GREEN}console${RESET}|${GREEN}test${RESET}|${GREEN}rubocop${RESET}|${GREEN}logs${RESET}}"
    echo "|----------------------------------------------------------"
    echo -e "|   ${BLUE}b${RESET}|${BLUE}build:${RESET} Build the project using docker compose"
    echo "|----------------------------------------------------------"
    echo -e "|   ${BLUE}s${RESET}|${BLUE}start:${RESET} Start the project by cleaning up and bringing up docker containers"
    echo "|----------------------------------------------------------"
    echo -e "|   ${BLUE}c${RESET}|${BLUE}console:${RESET} Enter the backend container's console"
    echo "|----------------------------------------------------------"
    echo -e "|   ${BLUE}t${RESET}|${BLUE}test:${RESET} Run RSpec tests"
    echo "|           Options:"
    echo "|                - -d => Reset the test database and run the migrations"
    echo "|----------------------------------------------------------"
    echo -e "|   ${BLUE}r${RESET}|${BLUE}rubocop:${RESET} Run Rubocop"
    echo "|----------------------------------------------------------"
    echo -e "|   ${BLUE}l${RESET}|${BLUE}logs:${RESET} Show logs"
    echo "|           Examples:"
    echo "|                - kb logs backend"
    echo "|                - kb logs back"
    echo "|                - kb logs b"
    echo "|                - kb l frontend"
    echo "|----------------------------------------------------------"
}


if [ $# -eq 0 ]; then
    help
    exit 1
fi

case "$1" in
  b|build)
    build
    ;;
  s|start)
    start
    ;;
  c|console)
    console
    ;;
  t|test)
    rspec "${@:2}"
    ;;
  r|rubocop)
    rubocop
    ;;
  l|logs)
    logs "${@:2}"
    ;;
  *)
    help
    ;;
esac
