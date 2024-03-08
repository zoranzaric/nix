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
}
