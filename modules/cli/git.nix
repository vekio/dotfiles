{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alberto Castañeiras";
        email = "alberto@casta.me";
      };
      init.defaultBranch = "main";
      gitflow.branch.master = "main";
      gitflow.branch.develop = "develop";
      gitflow.prefix.feature = "feature/";
      gitflow.prefix.release = "release/";
      gitflow.prefix.hotfix = "hotfix/";
      gitflow.prefix.support = "support/";
      gitflow.prefix.versiontag = "v";
    };
  };

  home.packages = with pkgs; [ gitflow ];
}
