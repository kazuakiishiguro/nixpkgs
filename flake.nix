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

            editorPackages = with pkgs; [
              emacs29
              screen
            ];

            utilPackages = with pkgs; [
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
            ];

            programmingPackages = with pkgs; [
              cargo
              rust-analyzer
            ];

            allPackages = editorPackages ++ utilPackages ++ programmingPackages;

            # Function to create the shellHook command
            mkShellHook = stowTargets: ''
              ${builtins.concatStringsSep "\n" (map (target: "stow -t ~ -v ${target}") stowTargets)}
            '';

        in
          {
            devShell = pkgs.mkShell {
              buildInputs = allPackages;
              shellHook = mkShellHook ["config" "emacs" "git" "zsh"];
            };
          }
      );
}
