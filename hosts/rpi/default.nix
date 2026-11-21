# Raspberry Pi 4 Model B (2GB). Headless: SSH + Tailscale.
#
# The same config builds the flashable SD image (packages.aarch64-linux.rpi-sd-image)
# and is what `nixos-rebuild switch --flake .#rpi` applies once it's running,
# so the image and the live system never drift apart.
{ lib, pkgs, modulesPath, ... }:
let
  keys = import ../../keys.nix;
in
{
  imports = [
    # Pi firmware + U-Boot + extlinux boot, and the NIXOS_SD / FIRMWARE
    # partition layout (also defines fileSystems."/" for the running system).
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  # Smaller image and faster builds: no ZFS kernel module.
  boot.supportedFilesystems.zfs = lib.mkForce false;
  # Wi-Fi/Bluetooth firmware (brcmfmac).
  hardware.enableRedistributableFirmware = true;

  # Root partition grows to fill the SD card on first boot (default true).
  sdImage.expandOnBoot = true;

  networking.hostName = "rpi";
  # Ethernet works out of the box. For Wi-Fi, after first boot:
  #   sudo nmcli device wifi connect <SSID> --ask
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  # 2GB RAM: compressed swap in RAM helps a lot with nix evaluation.
  zramSwap.enable = true;

  users.users.naikaayush = {
    isNormalUser = true;
    description = "Aayush";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ keys.macbook ];
  };
  # No password is set (SSH key login only), so sudo can't ask for one.
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # mDNS so the Pi is reachable as rpi.local before Tailscale is set up.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings.publish = {
      disable-publishing = false;
      publish-addresses = true;
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 7297 ];
  users.users.naikaayush.linger = true;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [ git vim htop ghostty.terminfo ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Lets the Mac push builds here with `nixos-rebuild --target-host`.
    trusted-users = [ "root" "@wheel" ];
    auto-optimise-store = true;
  };
  # SD cards are small: clean old generations weekly.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.11";
}
