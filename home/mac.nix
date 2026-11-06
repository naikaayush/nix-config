{ pkgs, ... }:
{
  home.username = "aayushnaik";
  home.homeDirectory = "/Users/aayushnaik";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    nixfmt
    websocat
    wimlib
    redis
    rubyPackages.cocoapods
    testdisk
    go
    nmap
    terraform
    awscli2
    pandoc
    protobuf
  ];

  programs.home-manager.enable = true;
}
