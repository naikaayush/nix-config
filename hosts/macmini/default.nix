# Host-specific config for the Mac mini (8GB RAM). Shared bits live in ../darwin.
{ ... }:
{
  # Installed with Determinate Nix, which manages the Nix daemon itself.
  nix.enable = false;
}
