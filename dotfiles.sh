os="$(uname -r)"
if [[ $os == *"arch"* ]]; then
    curl https://raw.githubusercontent.com/mnussbaum/ansible-yay/master/yay -o ~/.config/dotfiles/library/yay
    curl https://raw.githubusercontent.com/MarchCraft/dotfiles/master/arch.yaml -o ~/.config/dotfiles/arch.yaml
    ansible-playbook ~/.config/dotfiles/arch.yaml --ask-become-pass
fi

if [[ $os == *"fedora"* ]]; then
    curl https://raw.githubusercontent.com/MarchCraft/dotfiles/master/fedora.yaml -o ~/.config/dotfiles/fedora.yaml
    ansible-playbook ~/.config/dotfiles/fedora.yaml --ask-become-pass
fi

if [[ $os == *"asahi"* ]]; then
    curl https://raw.githubusercontent.com/MarchCraft/dotfiles/master/fedora.yaml -o ~/.config/dotfiles/fedora.yaml
    ansible-playbook ~/.config/dotfiles/fedora.yaml --ask-become-pass
fi
