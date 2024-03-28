#!/bin/fish

set original_dir (pwd)
set file (fd . ~ | fzf --preview "bat --theme Catppuccin-mocha --color=always {}" --preview-window=right:60%:wrap)

if test -d $file
    cd $file
    tmux new-session "nvim ."
else
    cd (dirname $file)
    set file (basename $file)
    tmux new-session "nvim $file"
end

cd $original_dir

clear
fastfetch
fish_prompt
