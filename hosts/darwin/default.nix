# Shared nix-darwin config for every mac.
{ config, lib, pkgs, ... }:
{
  # Required by nix-darwin
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.aayushnaik.home = "/Users/aayushnaik";
  system.primaryUser = "aayushnaik";
  system.defaults.dock = {
    wvous-tr-corner = 2;  # Top-right: Desktop
  };

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

  # Tailscale daemon (open-source tailscaled, no GUI app). Starts at boot,
  # before login. First run: `sudo tailscale up`.
  services.tailscale.enable = true;
  launchd.daemons.tailscaled.serviceConfig.KeepAlive = true;

  # Rex: put its bin dir on PATH when set.
  environment.interactiveShellInit = ''
    if [ -n "$REX_BIN_DIR" ]; then
      export PATH="$REX_BIN_DIR:$PATH"
    fi
  '';

  nixpkgs.config.allowUnfree = true;
}
