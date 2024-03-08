{ pkgs, ... }:
{
  # backwards compat; don't change
  system.stateVersion = 4;

  # existing config
  # build-users-group = nixbld
  # bash-prompt-prefix = (nix:$name)\040
  # extra-nix-path = nixpkgs=flake:nixpkgs

  nix = {
    package = pkgs.nixFlakes; # NOTE: EXPERIMENTAL.
    extraOptions = "experimental-features = nix-command flakes repl-flake";
    settings = {
      max-jobs = "auto";
    };
    useDaemon = true;
  };


  # here go the darwin preferences and config items
  system = {
    defaults = {
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;
      NSGlobalDomain.AppleShowAllExtensions = true;

      # 120, 94, 68, 35, 25, 15
      # NSGlobalDomain.InitialKeyRepeats = 25; # default: 25
      # 120, 90, 60, 30, 12, 6, 2
      # NSGlobalDomain.KeyRepeat = 6; # default: 6

      dock = {
        autohide = true;
        orientation = "left";
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

  };

  security.pam.enableSudoTouchIdAuth = true;

  # homebrew = {
  #   enable = true;
  #   caskArgs.no_quarantine = true;
  #   global.brewfile = true;
  #   masApps = { };
  #   casks = [ "raycast" "amethyst" ];
  #   taps = [ "fujiapple852/trippy" ];
  #   brews = [ "trippy" ];
  # };
}
