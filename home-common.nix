{ pkgs, ... }:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      rnix-lsp
      nixpkgs-fmt

      du-dust
    ];

    file = {
      "${config.home.homeDirectory}/.local/bin/git-silent-add" = {
        enable = true;
        executable = true;
        text =
          ''
            #!/bin/bash

            set -e

            git add --force --intent-to-add $@
            git update-index --assume-unchanged $@
          '';
      };
    };
  };

  programs.home-manager.enable = true;
}
