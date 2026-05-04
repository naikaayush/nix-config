{ pkgs, ... }:
{
  home.username = "aayushnaik";
  home.homeDirectory = "/Users/aayushnaik";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    nixfmt
  ];

  programs.home-manager.enable = true;
}
