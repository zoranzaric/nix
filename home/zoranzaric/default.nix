{ pkgs, lib, config, ... }:
{
  home = {
    username = "zoranzaric";
    homeDirectory = lib.mkForce "/Users/zoranzaric";

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
}
