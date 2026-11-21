# Host-specific config for the original mac. Shared bits live in ../darwin.
{ ... }:
{
  # Small aarch64-linux VM that nix uses as a remote builder, so this mac can
  # build NixOS for the Raspberry Pi (`nix build .#packages.aarch64-linux.rpi-sd-image`).
  nix.linux-builder.enable = true;
}
