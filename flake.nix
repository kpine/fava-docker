{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    #supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [python312] #virtualenv]
          ++ (with pkgs.python312Packages; [
            # a2wsgi
            # pip
            # uvicorn
            fava
          ]);
        # ++ (with pkgs.python312Packages; [
        #   (fava.overridePythonAttrs (oldAttrs: rec {
        #     version = "1.27.2";
        #     src = oldAttrs.src.override {
        #       inherit version;
        #       hash = "sha256-W/uxzk+/4tDVOL+nVUJfyBAE5sI9/pYq1zu42GCGjSk=";
        #     };
        #   }))
        # ]);
        shellHook = ''
          export BEANCOUNT_FILE="$PWD/example.beancount"
        '';
      };
    });
  };
}
