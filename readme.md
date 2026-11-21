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

`sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#<host>` (`mac` or `macmini`)

`sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin`
`sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`

3. `sudo darwin-rebuild switch --flake .#<host>` (`mac` or `macmini`)

## nixos

`sudo nixos-rebuild switch --flake .#nixos`

## rpi (Raspberry Pi 4)

Config lives in `hosts/rpi/`. The same config builds the SD image and is what you rebuild on the Pi later.

1. on the mac, enable the aarch64-linux builder VM once (`nix.linux-builder` in `hosts/mac`):

`sudo darwin-rebuild switch --flake .#mac`

2. build the image (kernel/firmware come from the binary cache, nothing compiles):

`nix build .#packages.aarch64-linux.rpi-sd-image`

3. flash it. Find the card with `diskutil list`, then (replace `diskN`):

`diskutil unmountDisk /dev/diskN`
`nix run nixpkgs#zstd -- -dc result/sd-image/*.img.zst | sudo dd of=/dev/rdiskN bs=4m`
`diskutil eject /dev/diskN`

4. boot the Pi on ethernet, then `ssh naikaayush@rpi.local` and `sudo tailscale up`.
   For wifi: `sudo nmcli device wifi connect <SSID> --ask`.

5. later changes: clone this repo on the Pi and run `sudo nixos-rebuild switch --flake .#rpi`.
