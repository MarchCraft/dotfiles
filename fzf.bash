#!/bin/bash
# find.sh
# List all files in the current directory and its subdirectories in fzf and open the selected file in nvim
# Usage: find.sh
# Dependencies: fzf, nvim

find . -type f | fzf --preview 'bat --style=numbers --color=always {}' | xargs nvim
