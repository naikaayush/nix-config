# mac
## bootstrap

1. install nix

`curl -fsSL https://install.determinate.systems/nix | sh -s -- install`

2. first run

`sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#mac`

`sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin`
`sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`


## nixos

`sudo nixos-rebuild switch --flake .#nixos`