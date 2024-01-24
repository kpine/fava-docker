{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [python311 virtualenv]
          ++ (with pkgs.python311Packages; [
            a2wsgi
            pip
            uvicorn
          ])
          ++ (with pkgs.python311Packages; [
            (fava.overridePythonAttrs (oldAttrs: rec {
              version = "1.27.1";
              src = oldAttrs.src.override {
                inherit version;
                hash = "sha256-W/uxzk+/4tDVOL+nVUJfyBAE5sI9/pYq1zu42GCGjSk=";
              };
            }))
          ]);
        shellHook = ''
          export BEANCOUNT_FILE="$PWD/example.beancount"
        '';
      };
    });
  };
}
