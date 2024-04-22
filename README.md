## Rename the .env.example file to .env

Fill the .env file with your own values

## Install the precommit hooks

It will run rubocop and rspec before each commit

```bash
./setup.sh
```

## Build and run the docker containers

```bash
./build_project.sh
./start_project.sh
```

## Enter into the backend container

/!\ If you use a `rails generate` command, you will need to add the user permission to edit the file
from your IDE. Run `chmod 777 -R .` in the backend container to fix this issue.

```bash
./exec_backend_console.sh
```
