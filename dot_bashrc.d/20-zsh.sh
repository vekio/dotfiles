# Auto-switch to zsh in interactive shells (useful for toolbox)
# Only exec zsh when it's available and we have a real terminal.
if [ -t 1 ] && command -v zsh >/dev/null 2>&1; then
  exec zsh
fi
