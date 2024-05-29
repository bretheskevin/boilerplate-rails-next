#!/bin/bash

USERNAME=$(logname)
if [ "`id -u`" -ne 0 ]; then
 echo "Switching from `id -un` to root"
 exec sudo "$0"
 exit 99
fi

bash_completion() {
  apt install bash-completion

  commands="build start console test rubocop logs"

   sed -i "/^alias kb_path=/d" /home/$USERNAME/.bashrc
   echo "alias kb_path='$(pwd)'" >> /home/$USERNAME/.bashrc

   sed -i "/^alias kb=/d" /home/$USERNAME/.bashrc
   echo "alias kb='$(pwd)/.dev/kb.sh'" >> /home/$USERNAME/.bashrc

  if ! grep -q "source /etc/profile.d/bash_completion.sh" /home/$USERNAME/.bashrc; then
    echo "source /etc/profile.d/bash_completion.sh" >> /home/$USERNAME/.bashrc
  fi

  if ! grep -q "complete -W '${commands}' kb" /home/$USERNAME/.bashrc; then
    echo "complete -W '${commands}' kb" >> /home/$USERNAME/.bashrc
  fi
}

install_precommit() {
       PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
       sed -i "s/PROJECT_NAME=\".*\"/PROJECT_NAME=\"$PROJECT_NAME\"/g" .dev/pre-commit
       cp .dev/pre-commit .git/hooks/pre-commit
}

install_precommit
bash_completion
