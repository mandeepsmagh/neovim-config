# Install rustup
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install nix
curl -L https://nixos.org/nix/install | sh

# Source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# Install packages
nix-env -iA \
	nixpkgs.git \
	nixpkgs.neovim \
	nixpkgs.tmux \
	nixpkgs.yarn \
	nixpkgs.ripgrep \
	nixpkgs.gcc \
    nixpkgs.fish \
