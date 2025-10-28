{ ... }: {
  # TODO customize fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # defaultOptions =
    #   [ "--height 40%" "--layout=reverse" "--border" "--inline-info" ];
    # historyWidgetOptions = [
    #   "--sort"
    #   "--exact"
    #   "--preview-window=down:3:hidden"
    #   "--bind=?:toggle-preview"
    #   "--bind=alt-a:select-all,alt-d:deselect-all"
    # ];
  };

  # home.packages = with pkgs; [ zsh-forgit zsh-fzf-history-search zsh-fzf-tab ];
}
