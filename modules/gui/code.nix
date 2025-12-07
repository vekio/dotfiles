{ config, pkgs, ... }:

let
  vscodeExtensions = pkgs.nix4vscode.forVscode [
    "openai.chatgpt"
    "a-h.templ"
    "Serhioromano.vscode-gitflow"
    "redhat.ansible"
    "redhat.vscode-yaml"
    "ms-python.python"
    "hashicorp.terraform"
  ];
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = (with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        usernamehw.errorlens
        asciidoctor.asciidoctor-vscode
        golang.go
        ms-vscode.live-server
        vue.volar
        docker.docker
        bradlc.vscode-tailwindcss
        astro-build.astro-vscode

        # Themes
        # github.github-vscode-theme
        catppuccin.catppuccin-vsc

        # Icons
        # vscode-icons-team.vscode-icons
        catppuccin.catppuccin-vsc-icons

        # Extensions without nix package
        # pomdtr.excalidraw-editor
        # a-h.templ
        # Serhioromano.vscode-gitflow
      ]) ++ vscodeExtensions;

      userSettings = {
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.colorTheme" = "Catppuccin Mocha"; # "GitHub Dark Default"
        "workbench.sideBar.location" = "right";
        "terminal.integrated.stickyScroll.enabled" = false;

        "files.autoGuessEncoding" = true;
        "files.trimFinalNewlines" = true;
        "files.insertFinalNewline" = true;
        "files.trimTrailingWhitespace" = true;

        "editor.formatOnSave" = true;
        "editor.renderFinalNewline" = "off";
        "editor.fontFamily" = "FiraCode Nerd Font";
        "editor.fontLigatures" = true;
        "editor.fontWeight" = "normal";
        "editor.cursorStyle" = "block";

        "git.autofetch" = true;

        "vsicons.dontShowNewVersionMessage" = true;
        "redhat.telemetry.enabled" = false;
      };

      keybindings = [
        # Activar copyLinesUpAction
        {
          key = "shift+alt+up";
          command = "editor.action.copyLinesUpAction";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "shift+alt+down";
          command = "editor.action.copyLinesDownAction";
          when = "editorTextFocus && !editorReadonly";
        }
        # Desactivar copyLinesUpAction
        {
          key = "ctrl+shift+alt+up";
          command = "-editor.action.copyLinesUpAction";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+shift+alt+down";
          command = "-editor.action.copyLinesDownAction";
          when = "editorTextFocus && !editorReadonly";
        }
        # Activar insertCursorAbove
        {
          key = "ctrl+alt+up";
          command = "editor.action.insertCursorAbove";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+down";
          command = "editor.action.insertCursorBelow";
          when = "editorTextFocus";
        }
        # Desactivar insertCursorAbove
        {
          key = "ctrl+shift+up";
          command = "-editor.action.insertCursorAbove";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+down";
          command = "-editor.action.insertCursorBelow";
          when = "editorTextFocus";
        }
        {
          key = "shift+alt+up";
          command = "-editor.action.insertCursorAbove";
          when = "editorTextFocus";
        }
        {
          key = "shift+alt+down";
          command = "-editor.action.insertCursorBelow";
          when = "editorTextFocus";
        }
      ];
    };

  };
}
