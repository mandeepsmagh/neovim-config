# neovim-config

Neovim config with native LSP in main branch. Old `coc` related settings are available under `coc` branch. 

## Pre-requisites

- [Neovim 0.7.0 install page](https://github.com/neovim/neovim/releases/tag/v0.7.0)
- I recommend using [Nix Package Manager](https://nixos.org/download.html) to install / manage neovim for Linux / MacOS
- [Use a Nerd Font](https://www.nerdfonts.com/) in your terminal emulator.

### Must-have for fully functional nvim config  

- [`rust`](https://www.rust-lang.org/tools/install) is required for ripgrep.
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) is required for grep searching with _Telescope_

## Install

### Linux and MacOS
Clone repo (Example uses ssh url to clone repo) and install required plugins:

```shell
git clone git@github.com:mandeepsmagh/neovim-config.git ~/.config/nvim --depth 1
```

### Windows

1. Install [`mingw`](http://mingw-w64.org) if you don't already have it.

```shell
choco install mingw
```

2. Install `packer`

```shell
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
git clone git@github.com:mandeepsmagh/neovim-config.git --depth 1
```

3. Copy the nvim dir to `~/AppData/Local/`

## Uninstall

Uninstalling is as simple as removing the `nvim` configuration directories.

```shell
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

## Want to try my config in your system

1. Backup your current config under different name

```shell
mv nvim NVIM_BAK
```

2. Follow above installation steps.

3. Want to revert back to your config ?
- Follow uninstall steps
- restore your config by renaming it back to original



