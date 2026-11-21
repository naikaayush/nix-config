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

Headless Pi 4 (2GB): SSH, Tailscale, zsh + oh-my-zsh.

- `hosts/rpi/` — system config. Also builds the SD image, so image and live system match.
- `home/rpi.nix` — home-manager (shell, git, neovim). CLI only, no GUI apps.

### build the image (on the mac)

The mac builds aarch64-linux in a Linux VM (`nix.linux-builder` in `hosts/mac`). Enable it once:

`sudo darwin-rebuild switch --flake .#mac`

Then build. Kernel/firmware come from the binary cache, nothing compiles:

`nix build .#packages.aarch64-linux.rpi-sd-image`

Output: `result/sd-image/nixos-image-sd-card-*.img.zst` (~1.5 GB, zstd-compressed).

### flash the SD card (on the mac)

Erases the whole card.

1. find the card: `diskutil list physical`. The MacBook's slot shows as
   "Built In SDXC Reader" (`diskutil info /dev/diskN`), marked internal but removable.
   Never use `disk0` (the mac's SSD). Below, replace `diskN` with the card.
2. `sudo -v` (enter password before the pipe starts)
3. `diskutil unmountDisk /dev/diskN`
4. `nix run nixpkgs#zstd -- -dc result/sd-image/*.img.zst | sudo dd of=/dev/rdiskN bs=4m status=progress`
   (`rdiskN` = raw device, much faster than `diskN`)
5. `diskutil eject /dev/diskN`

"Permission denied" / "Read-only file system" → slide the card's lock switch to unlocked.

### first boot

1. insert card, plug in ethernet, power on. First boot grows the root partition to fill the card; give it a minute or two.
2. `ssh naikaayush@rpi.local` (mDNS). Doesn't resolve → use the IP from the router.
3. `sudo tailscale up`, open the login link. After that: `ssh naikaayush@rpi`.
4. wifi (optional): `sudo nmcli device wifi connect <SSID> --ask`

### updates (on the pi)

Push to tangled first, then on the Pi, once:

`git clone https://tangled.org/naikaayush.com/nix-config ~/nix-config`
`sudo nixos-rebuild switch --flake ~/nix-config#rpi`

After that, `update` pulls and rebuilds (alias in `home/rpi.nix`).
