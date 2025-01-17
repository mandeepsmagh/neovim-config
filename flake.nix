{
  description = "Nix system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    system = "aarch64-darwin";

    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

  in {
    packages.${system} = {
      default = pkgs.buildEnv {
        name = "my-packages";
        paths = with pkgs; [
          git
          nodejs
          python3
          neovim
        ];
      };

    };
  };
}


