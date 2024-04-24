# Template Next.js / Ruby on Rails

## Prerequisites

- bash (The setup script use the .bashrc for aliases)
- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/linux/)
  - /!\ It won't work with the old version that uses `docker-compose`, you need to install the latest one that use `docker compose`

## Get started

Rename the `.env.example` file to `.env` and fill it with you own values

## Set up the project

The following script will :

- Install the pre-commit hooks (`rubocop` and `rspec`)
- Add an alias named `kb` to the `.dev/kb.sh` file
- Add auto-completion for the `kb` alias

```bashg
./setup.sh
```

**Make sure to restart your terminal or source the `.bashrc` file**

Execute `kb` to see the available commands

## Ports

- Frontend: 4200
- Backend: 3000

Nginx should redirect the frontend to `localhost` and the backend to `localhost/api`.
If it only works by specifying the port, you can try to open the page in a private browser mode.

## Features

**BACKEND**

- [x] Rubocop (with rspec and factory-bot plugins)
- [x] Rspec
- [x] Crud concern
- [x] Pagination for the index action
- [x] Serializer
- [x] Authentication with devise
- [x] Pundit gem for authorization (roles)

**Frontend**

- [x] ESLint
- [x] Prettier
- [x] Tailwind
- [x] ApiService
    - CRUD methods
    - Send authorization token
    - Manage search params
- [x] AuthService
- [x] EntityManager (automatically fetch data from the API)
- [x] Model
- [x] Example page with some entity manager actions

## TODO

- [ ] Return 404 at POST /users (devise make it buggy)
