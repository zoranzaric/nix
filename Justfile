_default:
  just --list

dev:
  nix develop

darwin-rebuild-switch:
  nix build .#darwinConfigurations.$(hostname -s).system --extra-experimental-features nix-command --extra-experimental-features flakes
  result/sw/bin/darwin-rebuild switch --flake .#$(hostname -s)

home-manager-switch:
  nix run github:nix-community/home-manager -- switch --flake .
