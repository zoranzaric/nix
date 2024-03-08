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
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToEscape = true;
    defaults = {
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;
      dock.autohide = true;
      NSGlobalDomain.AppleShowAllExtensions = true;
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 1;
    };
  };

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
