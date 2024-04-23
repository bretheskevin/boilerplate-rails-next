bash_completion() {
  sudo apt install bash-completion

  commands="build start console"

  if ! grep -q "alias kb_path='$(pwd)'" ~/.bashrc; then
    echo "alias kb_path='$(pwd)'" >> ~/.bashrc
  fi

  if ! grep -q "alias kb='$(pwd)/.dev/kb.sh'" ~/.bashrc; then
    echo "alias kb='$(pwd)/.dev/kb.sh'" >> ~/.bashrc
  fi

  if ! grep -q "source /etc/profile.d/bash_completion.sh" ~/.bashrc; then
    echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc
  fi

  if ! grep -q "complete -W '${commands}' kb" ~/.bashrc; then
    echo "complete -W '${commands}' kb" >> ~/.bashrc
  fi
}

install_precommit() {
       PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
       sed -i "s/PROJECT_NAME=\".*\"/PROJECT_NAME=\"$PROJECT_NAME\"/g" .dev/pre-commit
       cp .dev/pre-commit .git/hooks/pre-commit
}

install_precommit
bash_completion
