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

          pingus-htdocs-serve = pkgs.writers.writePython3Bin "pingus-htdocs-serve" {
            flakeIgnore = [ "E501" ];
          } ''
            import functools
            import http.server
            import threading
            import webbrowser

            handler = functools.partial(
                http.server.SimpleHTTPRequestHandler,
                directory="${pingus-htdocs}")

            with http.server.ThreadingHTTPServer(("127.0.0.1", 0), handler) as httpd:
                url = f"http://127.0.0.1:{httpd.server_address[1]}/"
                print(f"Serving pingus-htdocs at {url} (Ctrl-C to stop)", flush=True)
                threading.Timer(0.5, webbrowser.open, args=[url]).start()
                try:
                    httpd.serve_forever()
                except KeyboardInterrupt:
                    pass
          '';
        };

        apps = rec {
          default = serve;

          serve = flake-utils.lib.mkApp {
            drv = self.packages.${system}.pingus-htdocs-serve;
          };
        };
      }
    );
}
