#!/bin/fish
# find.sh
# List all files in the current directory and its subdirectories in fzf and save 
# the selected file to a variable. Then open the file in nvim.
# Usage: find.sh
# Dependencies: fzf, nvim

set original_dir (pwd)
set file (fd | fzf --preview "bat --color=always {}" --preview-window=right:60%:wrap)

if test -d $file
    cd $file
    tmux new-session -A -s "nvim" "nvim ."
else
    cd (dirname $file)
    tmux new-session -A -s "nvim" "nvim $file"
end

cd $original_dir
clear
fastfetch
fish
