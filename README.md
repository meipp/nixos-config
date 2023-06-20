# nixos-config

# Setup
`cd` into this repo and create a symlink to `configuration.nix` in `/etc/nixos`.
```sh
cd nixos-config
ln -s configuration.nix /etc/nixos/configuration.nix
```

## Dependencies
Requires an already generated `/etc/nixos/hardware-configuration.nix`.

## Credits
- [vinceliuice/grub2-themes](https://github.com/vinceliuice/grub2-themes) for `grub-themes/{stylish,tela,vimix,whitesur}`
- [shvchk/poly-light](https://github.com/shvchk/poly-light) for `grub-themes/poly-light`
- [avivace/breeze2-sddm-theme](https://github.com/avivace/breeze2-sddm-theme) for `sddm-themes/breeze`
