# home-manager config for naikaayush on the Raspberry Pi. Headless and small:
{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.rex.homeManagerModules.default ];

  home.username = "naikaayush";
  home.homeDirectory = "/home/naikaayush";
  home.stateVersion = "26.11";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      # Rebuild from the clone in ~/nix-config (see readme).
      update = "git -C ~/nix-config pull && sudo nixos-rebuild switch --flake ~/nix-config#rpi";
      ts = "tailscale status";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "tailscale" ];
      theme = "robbyrussell";
    };
  };

  home.packages = with pkgs; [
    wget
    jq
    gh
    wakeonlan
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings.macmini = {
      HostName = "192.168.0.111";
      User = "aayushnaik";
    };
  };

  programs.rex.enable = true;
  services.rex.enable = true;
  services.rex.extraListen = [ "tailnet://:7297" ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Aayush Naik";
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
