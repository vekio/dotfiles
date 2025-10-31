{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 100000;
    sensibleOnTop = true;

    terminal = "tmux-256color";

    extraConfig = ''
      set -g mouse on
      set -as terminal-features ",alacritty:RGB"
      set -g set-clipboard on
      # Opcionales finos:
      set -g renumber-windows on
      set -g escape-time 10
      setw -g mode-keys vi
    '';

    # ⚙️ Plugins
    plugins = with pkgs.tmuxPlugins; [
      # 🎨 Catppuccin Mocha Theme
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"

          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag  status-right "#{E:@catppuccin_status_session}"
          set -ag  status-right "#{E:@catppuccin_status_uptime}"
          set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      }

      # 🔋 CPU + Battery indicators
      cpu
      battery

      # 💾 Session persistence
      # {
      #   plugin = resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
      # {
      #   plugin = continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-save-interval '60'
      #   '';
      # }
    ];
  };
}
