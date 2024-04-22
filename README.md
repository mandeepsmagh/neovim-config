# neovim-config

Neovim config with native LSP in `main` branch. Old `coc` related settings are available under `coc` branch. 

## Pre-requisites

- [Neovim 0.9.5 install page](https://github.com/neovim/neovim/releases/tag/v0.9.5)
- I recommend using [Nix Package Manager](https://nixos.org/download.html) to install / manage neovim for Linux / MacOS
- [Use a Nerd Font](https://www.nerdfonts.com/) in your terminal emulator.

`install.sh` script is also available in the directory to automatically install everything. 

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

1. Install Neovim using `winget`

```powershell
winget install Neovim.Neovim
```

2.(Optional) Install zig to resolve this error - No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable.

```powershell
winget install -e --id zig.zig

```
3. Clone repo 

```powershell
git clone git@github.com:mandeepsmagh/neovim-config.git --depth 1 $env:USERPROFILE\AppData\Local\nvim\
```
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



