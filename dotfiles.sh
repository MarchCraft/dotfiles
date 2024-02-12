mkdir ~/.config/dotfiles
curl https://raw.githubusercontent.com/MarchCraft/dotfiles/master/playbook.yml -o ~/.config/dotfiles/playbook.yml
ansible-playbook ~/.config/dotfiles/playbook.yml --ask-become-pass
