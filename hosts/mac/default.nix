{ pkgs, ... }:
{
  # Required by nix-darwin
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";  # match flake.nix

  users.users.aayushnaik.home = "/Users/aayushnaik";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.trusted-users = [ "@admin" "aayushnaik" ];

  # The Linux builder — runs as a launchd daemon
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder.diskSize = 40 * 1024;
        darwin-builder.memorySize = 8 * 1024;
        cores = 6;
      };
    };
  };

  nix.settings.builders-use-substitutes = true;

  programs.zsh.enable = true;
}