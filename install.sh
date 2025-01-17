#!/bin/sh
# not-tested
# Install rustup
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install Nix using Determinate Systems installer with silent mode
# will probably still require user to enter password
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm --no-modify-profile

# Source Nix manually as we disabled profile modification
. ~/.nix-profile/etc/profile.d/nix.sh

# Copy flake.nix to .config/nix
mkdir -p ~/.config/nix
cp flake.nix ~/.config/nix/flake.nix

# Install packages from flake
nix profile install ~/.config/nix#
