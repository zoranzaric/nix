{ pkgs, lib, ... }:
{
  home = {
    username = "zoranzaric";
    homeDirectory = lib.mkForce "/Users/zoranzaric";
  };
}
