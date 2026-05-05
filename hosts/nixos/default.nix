{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time & locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # X11 + KDE Plasma 6
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Audio (pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.naikaayush = {
    isNormalUser = true;
    description = "Aayush";
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    shell = pkgs.zsh;
  };

  # Cloudflare Tunnel (token-based; tunnel configured in the Zero Trust dashboard).
  # Token is read from /etc/cloudflared/token.env, which must contain:
  #   TUNNEL_TOKEN=<token>
  # Create it with: sudo install -m 600 -o root -g root /dev/stdin /etc/cloudflared/token.env
  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${TUNNEL_TOKEN}";
      EnvironmentFile = "/etc/cloudflared/token.env";
      Restart = "on-failure";
      RestartSec = 5;
      DynamicUser = true;
    };
  };

  services.openssh = {                                                                             
      enable = true;                                                                                 
      settings = {                                                                                   
        PasswordAuthentication = false;
        PermitRootLogin = "no";                                                                      
      };          
  };
  users.users.naikaayush.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhfIUnPqmIpQPGJwXgn61f+R/dRHi4di76Ix+OJn0P5"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKO9j5PVk/yOUe1YIpHb8mEUJl3/ewusb0NbEVfBgUst"
  ];
  
  # Firecracker
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.nat = {
    enable = true;
    externalInterface = "wlp5s0";
    internalInterfaces = [ "tap0" ];
  };

  # Programs
  programs.zsh.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ pkgs.ghostty.terminfo ];

  # Enable flakes for `nixos-rebuild --flake`
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}