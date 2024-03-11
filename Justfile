_default:
  just --list

dev:
  nix develop

alias drs := darwin-rebuild-switch
darwin-rebuild-switch:
  nix build .#darwinConfigurations.$(hostname -s).system --extra-experimental-features nix-command --extra-experimental-features flakes
  result/sw/bin/darwin-rebuild switch --flake .#$(hostname -s)
  # git commit --all --allow-empty --message "$(nix-env --list-generations | grep current)"

alias hms := home-manager-switch
home-manager-switch:
  nix run github:nix-community/home-manager -- switch --flake .

brew-list:
  brew leaves