{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Alberto Castañeiras";
    userEmail = "alberto@casta.me";
    extraConfig = {
      init.defaultBranch = "main";
      gitflow.branch.master = "main";
      gitflow.branch.develop = "dev";
      gitflow.prefix.feature = "feature/";
      gitflow.prefix.release = "release/";
      gitflow.prefix.hotfix = "hotfix/";
      gitflow.prefix.support = "support/";
      gitflow.prefix.versiontag = "v";
    };
  };

  home.packages = with pkgs; [ gitflow ];
}
