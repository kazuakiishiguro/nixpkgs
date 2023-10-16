{
  description = "Kazuaki Ishiguro's nix configuration";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(
      system:
        let inherit (nixpkgs.lib) optional;
            pkgs = import nixpkgs { inherit system; };
        in
          {
            devShell = pkgs.mkShell {
              buildInputs = with pkgs; [
                # editor
                emacs29
                screen

                # util
                bat
                bash
                curl
                fzf
                htop
                gnupg
                jq
                mosh
                screen
                stow
                tree
                wget
                zsh

                # programming
                cargo
                rust-analyzer
              ];

              # TODO: Any better ways?
              shellHook = ''
                stow -t ~ -v config
                stow -t ~ -v emacs
                stow -t ~ -v git
                stow -t ~ -v zsh
              '';
            };
          }
      );
}
