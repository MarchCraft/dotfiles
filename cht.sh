#!/bin/bash
# cht.sh - cheat.sh


languuages=`echo "lua python java rust LaTeX git" | tr ' ' '\n'`
core_utils=`echo "xargs find grep" | tr ' ' '\n'`

selected=$(printf "$languuages\n$core_utils" | fzf)
read -p "Enter query: " query

if printf "%s" "$languuages" | grep -q "$selected"; then
    tmux neww bash -c "curl cht.sh/$selected/`echo $query | tr ' ' '+'` & while [ : ]; do : sleep 1; done"
else
    tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do : sleep 1; done"
fi
