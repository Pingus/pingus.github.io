{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    pingus.url = "github:pingus/pingus";
  };

  outputs = { self, nixpkgs, flake-utils, pingus }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pingus-wasm = pingus.packages.${system}.pingus-wasm;
        pingus-android = pingus.packages.${system}.pingus-android;
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
              cp -vr ${pingus-wasm}/. $out/wasm/
            '';

            nativeBuildInputs = with pkgs; [
              python3Packages.libxslt.bin
              html-tidy
              rsync
            ];
          };
        };
      }
    );
}
