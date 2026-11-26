# Host-specific config for the original mac. Shared bits live in ../darwin.
{ ... }:
let
  keys = import ../../keys.nix;
in
{
  # Small aarch64-linux VM that nix uses as a remote builder, so this mac can
  # build NixOS for the Raspberry Pi (`nix build .#packages.aarch64-linux.rpi-sd-image`).
  nix.linux-builder = {
    enable = true;
    config.virtualisation = {
      cores = 6;
      darwin-builder.memorySize = 8 * 1024;
    };
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
    '';
  };

  users.users.aayushnaik.openssh.authorizedKeys.keys = [ keys.macbook keys.iphone ];
}
