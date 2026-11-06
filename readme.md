# mac

## layout

- `hosts/darwin/` — shared nix-darwin config for all macs
- `hosts/<host>/` — per-mac overrides (`mac`, `macmini`)
- `home/darwin.nix` — shared home-manager config (zsh + oh-my-zsh, packages)

To add a mac: create `hosts/<name>/default.nix` and add `<name> = mkDarwin "<name>";` in `flake.nix`.

After bootstrap: `sudo darwin-rebuild switch --flake .#<host>`

## bootstrap

1. install nix

`curl -fsSL https://install.determinate.systems/nix | sh -s -- install`

2. first run

`sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#<host>`  (`mac` or `macmini`)

`sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin`
`sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`

3. `sudo nixos-rebuild switch --flake .#<host>`  (`mac` or `macmini`)

## nixos

`sudo nixos-rebuild switch --flake .#nixos`