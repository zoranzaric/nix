{ pkgs, ... }:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      rnix-lsp
      nixpkgs-fmt

      du-dust
    ];
  };

  programs.home-manager.enable = true;
  # here go the mbp04 specific darwin preferences and config items
}
