# Auto-switch to fish in interactive shells
if [ -t 1 ] && command -v fish >/dev/null 2>&1; then
  exec fish
fi
