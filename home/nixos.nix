{ config, pkgs, ... }:
{
  home.username = "naikaayush";
  home.homeDirectory = "/home/naikaayush";
  home.stateVersion = "26.05";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
      theme = "robbyrussell";
    };
  };


  # User-level packages managed by home-manager.
  home.packages = with pkgs; [
    claude-code
    vscode
    google-chrome
    wget
    gh
    firecracker
    jq
    squashfsTools
    e2fsprogs
  ];

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
      user.email = "aayushnai@gmail.com";
      user.signingKey = "/home/naikaayush/.ssh/id_ed25519.pub";
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.format = "ssh";
    };
  };

  programs.home-manager.enable = true;
}