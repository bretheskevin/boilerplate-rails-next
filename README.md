# Template Next.js / Ruby on Rails

Your application will be served to [http://localhost/](http://localhost/)

## Prerequisites

- bash (The setup script use .bashrc for aliases)
- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/linux/)
    - /!\ It won't work with the old version that uses `docker-compose`, you need to install the latest one that
      use `docker compose` or add an alias in your `.bash_aliases` file.
- [Yarn](https://classic.yarnpkg.com/en/docs/install)

## Get started

Rename the `.env.example` file to `.env` and fill it with your own values

## Set up the project

The following script will :

- Install the pre-commit hooks (`rubocop` and `rspec`)
- Add an alias named `kb` to the `.dev/kb.sh` file
- Add auto-completion for the `kb` alias

```bash
./setup.sh
```

Then, go to the frontend folder, and install the depedencies

```bash
cd frontend
yarn install
```

# Make sure to restart your terminal or source the `.bashrc` file

Execute `kb` to see the available commands

### Commands

- `kb build` : Build the docker container
- `kb start` : Start / Restart the project
- `kb console` : Open a bash console in the backend container
- `kb test` : Run the tests
- `kb rubocop` : Run rubocop
- `kb logs` : Show the docker containers logs

## Ports

If you have any conflicts with the porte 3000, 4200 or 5432, you can change them in the `.env` file.
It will change the ports served by the docker container (it's normal that the ports don't change in the logs)

## Features

**Backend**

- [x] Rubocop (with rspec and factory-bot plugins)
- [x] Rspec
- [x] Crud concern
- [x] Pagination for the index action
- [x] Serializer
- [x] Authentication with devise
- [x] Pundit gem for authorization (roles)
- [ ] Scope to get deleted and inactivated models

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
- [ ] Type model.ts toJson()

## TODO

- [ ] Backend specs coverage 100%
