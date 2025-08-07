{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscode-icons-team.vscode-icons
      jnoortheen.nix-ide
      usernamehw.errorlens
      asciidoctor.asciidoctor-vscode
      golang.go
      ms-vscode.live-server
      github.github-vscode-theme
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons

      # Extensions without nix package
      # pomdtr.excalidraw-editor
      # a-h.templ
      # Serhioromano.vscode-gitflow
    ];

    profiles.default.userSettings = {
      "workbench.iconTheme" = "vscode-icons";
      "workbench.colorTheme" = "GitHub Dark Default";
      "workbench.sideBar.location" = "right";

      "files.autoGuessEncoding" = true;
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;

      "editor.formatOnSave" = true;
      "editor.renderFinalNewLine" = true;
      "editor.fontFamily" = "consolas";
      "editor.fontWeight" = "400";
      "editor.cursorStyle" = "block";

      "git.autofetch" = true;

      "vsicons.dontShowNewVersionMessage" = true;
    };
  };
}
