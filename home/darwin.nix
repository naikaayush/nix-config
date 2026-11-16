# Shared home-manager config for every mac.
{ config, lib, pkgs, ... }:
{
  home.username = "aayushnaik";
  home.homeDirectory = "/Users/aayushnaik";
  home.stateVersion = "24.11";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = with pkgs; [
    nixfmt
    websocat
    wimlib
    redis
    rubyPackages.cocoapods
    testdisk
    go
    nmap
    terraform
    awscli2
    pandoc
    protobuf

    # dev toolchains
    rustup
    fnm
    pnpm

    # apps / agents
    ghostty-bin
    claude-code
    codex
    herdr
    vscode
    gemini-cli
  ];

  # Git: name/email are mkDefault so a host can override them
  # (e.g. home-manager.users.aayushnaik.programs.git.settings.user.email = "...").
  programs.git = {
    enable = true;
    settings = {
      user.name = lib.mkDefault "Aayush Naik";
      user.email = lib.mkDefault "aayushnai@gmail.com";
      user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      init.defaultBranch = "main";
      pull.rebase = true;
      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.format = "ssh";
    };
  };

  # GitHub CLI; also acts as git's credential helper for github.com.
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "macos"
      ];
      theme = "robbyrussell";
    };

    # fnm: auto-switch node version from .nvmrc / .node-version on cd
    initContent = ''
      eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd --shell zsh)"
    '';
  };

  programs.home-manager.enable = true;
}
