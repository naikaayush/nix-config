# Host-specific config for the Mac mini (8GB RAM). Shared bits live in ../darwin.
{ ... }:
{
  # Installed with Determinate Nix, which manages the Nix daemon itself.
  nix.enable = false;

  # SSH server (Apple's built-in sshd, managed by nix-darwin). Key-only login.
  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
    '';
  };

  users.users.aayushnaik.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhfIUnPqmIpQPGJwXgn61f+R/dRHi4di76Ix+OJn0P5 aayush@macbook-pro"
  ];
}
