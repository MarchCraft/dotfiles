#!/bin/bash
# find.sh
# List all files in the current directory and its subdirectories in fzf and save 
# the selected file to a variable. Then open the file in nvim.
# Usage: find.sh
# Dependencies: fzf, nvim

clear
file=$(fd -H -E .git | fzf --height 60% --reverse --border --ansi --preview "bat --color=always --style=header,grid --line-range :500 {}" --preview-window=right:60%:wrap)

# detect if file is a directory
if [ -d "$file" ]; then
    cd "$file"
    tmux new-session -d -s "nvim" "nvim ."
else
    cd "$(dirname "$file")"
    basename=$(basename "$file")
    tmux new-session -d -s "nvim" "nvim $basename"
fi

tmux a
