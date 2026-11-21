# Shared nix-darwin config for every mac.
{ config, lib, pkgs, ... }:
{
  # Required by nix-darwin
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.aayushnaik.home = "/Users/aayushnaik";
  system.primaryUser = "aayushnaik";

  # Only when nix-darwin manages Nix. Hosts on Determinate Nix set
  # `nix.enable = false` (Determinate already enables flakes; extra settings
  # go in /etc/nix/nix.custom.conf).
  nix.settings = lib.mkIf config.nix.enable {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "@admin"
      "aayushnaik"
    ];
  };

  programs.zsh.enable = true;

  # Rex: put its bin dir on PATH when set.
  environment.interactiveShellInit = ''
    if [ -n "$REX_BIN_DIR" ]; then
      export PATH="$REX_BIN_DIR:$PATH"
    fi
  '';

  nixpkgs.config.allowUnfree = true;
}
