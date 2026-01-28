# Auto-switch to zsh in interactive shells (useful for toolbox)
if [ -t 1 ] && command -v zsh >/dev/null 2>&1; then
  exec zsh
fi

