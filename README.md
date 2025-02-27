# Boilerplate Next.js / Ruby on Rails

Your application will be served to [http://localhost/](http://localhost/)

## Prerequisites

- bash (The setup script use .bashrc for aliases)
- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/linux/)
    - /!\ It won't work with the old version that uses `docker-compose`, you need to install the latest one that
      use `docker compose`, or add an alias in your `.bash_aliases` file.
- [Yarn](https://classic.yarnpkg.com/en/docs/install)

If you're on macOS, [Orbstack](https://docs.orbstack.dev/) is a good alternative to Docker Compose, as it offers better performance 
and lower resource consumption compared to Docker Desktop.

## Get started

Rename the `.env.example` file to `.env` and fill it with your own values

## Set up the project


### Linux

The following script will :

- Install the pre-commit hooks (`rubocop` and `rspec`)
- Add an alias named `kb` to the `.dev/kb.sh` file
- Add auto-completion for the `kb` alias

```bash
./setup.sh
```

### MacOS

Add the permissions to the `.git` folder and execute the setup script

```bash
chmod -R 777 .git
./setup-macos.sh
```

#

Then, go to the frontend folder, and install the dependencies

```bash
cd frontend
yarn install
```

The app will be accessible at [http://localhost/](http://localhost/), don't specify the port, or you will get a CORS
error during API calls.

# Make sure to restart your terminal or source the `.bashrc` file

Execute `kb` to see the available commands

### Commands

- `kb build` : Build the docker container
- `kb start` : Start / Restart the project
- `kb console` : Open a bash console in the backend container
- `kb test` : Run the tests
- `kb test_front` : Run Vitest tests
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
- [x] Scope to get deleted models

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
- [x] [Shadcn](https://ui.shadcn.com/) library for the UI
- [x] [Zod](https://zod.dev/) lib added for form validation
- [x] [Vitest](https://vitest.dev/) lib added for testing

**TODO**

- [ ] Migrate Rails.application.secrets to Rails.application.credentials
- [ ] Multiple /get depth frontend Model convertor (ex: User have multiple Post, post have to be converted to Post model instead of just having the json)
- [ ] Remove every any from frontend
- [ ] Add adminer
- [ ] Merge setup.sh script into one file instead of having 2 differents scripts depending of the os
