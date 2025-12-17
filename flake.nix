# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
#
# fireflag - Nix Flake (RSR Fallback)
# Primary package manager: Guix (see guix.scm)
# Usage: nix develop or nix build

{
  description = "fireflag - Feature flag management with fire-and-forget semantics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "fireflag";
            version = "0.1.0";

            src = ./.;

            meta = with pkgs.lib; {
              description = "Feature flag management with fire-and-forget semantics";
              homepage = "https://github.com/hyperpolymath/fireflag";
              license = with licenses; [ agpl3Plus mit ];
              maintainers = [ ];
              platforms = platforms.all;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Build tools
            gnumake
            just

            # Version control
            git

            # RSR tooling
            guix
          ];

          shellHook = ''
            echo "fireflag development shell"
            echo "Primary: guix shell -D -f guix.scm"
            echo "Fallback: nix develop (current)"
          '';
        };

        # Checks for CI
        checks = {
          format = pkgs.runCommand "check-format" { } ''
            cd ${self}
            echo "Format check placeholder"
            touch $out
          '';
        };
      }
    );
}
