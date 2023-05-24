{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = pingus-htdocs;

          pingus-htdocs = pkgs.stdenv.mkDerivation rec {
            pname = "pingus-htdocs";
            version = "0.0.0";

            src = ./.;

            buildPhase = ''
              make
            '';

            installPhase = ''
              mkdir $out
              cp -vr build/. $out/
            '';

            nativeBuildInputs = with pkgs; [
              pkgs.python310Packages.libxslt.bin
              html-tidy
              rsync
            ];
          };
        };
      }
    );
}
