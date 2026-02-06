# -----------------------------------------------------------------------------
# Containers
# -----------------------------------------------------------------------------
# Podman remote (use host engine from toolbox).
# Comment out because I use flatpak-spawn + alias workaround on the toolbox side.
# if [ -n "$TOOLBOX_PATH" ] && [ -S "/run/user/$(id -u)/podman/podman.sock" ]; then
#   export CONTAINER_HOST="unix:///run/user/$(id -u)/podman/podman.sock"
# fi
