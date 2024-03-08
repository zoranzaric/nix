{ pkgs, lib, config, ... }:
{
  home = {
    username = "zoranzaric";
    homeDirectory = lib.mkForce "/Users/zoranzaric";
  };
}
