# -----------------------------------------------------------------------------
# fzf key bindings
# -----------------------------------------------------------------------------
fzf_bindings=""

if [ -r /usr/share/fzf/shell/key-bindings.zsh ]; then
  fzf_bindings="/usr/share/fzf/shell/key-bindings.zsh"
elif [ -r /home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh ]; then
  fzf_bindings="/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.zsh"
fi

if [ -n "$fzf_bindings" ]; then
  source "$fzf_bindings"
fi
