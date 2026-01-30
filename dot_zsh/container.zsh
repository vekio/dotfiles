# Podman remote (use host engine from toolbox)
if [ -n "$TOOLBOX_PATH" ] && [ -S "/run/user/$(id -u)/podman/podman.sock" ]; then
  export CONTAINER_HOST="unix:///run/user/$(id -u)/podman/podman.sock"
fi

