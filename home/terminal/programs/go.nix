{
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    # this only clone the repository
    # doesn't install it
    # packages = {
    #   "github.com/spf13/cobra-cli" = builtins.fetchGit {
    #     url = "https://github.com/spf13/cobra-cli";
    #     rev = "74762ac083f2c4deffef229c887ffc15beb6ce0d"; # v1.3.0
    #   };
    # };
  };

  home.sessionPath = [ "$GOPATH" ];
}
