{
  description = "template";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    fourmolu = {
      url = "github:fourmolu/fourmolu/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
        haskellPackages = pkgs.haskell.packages.ghc902;
        project = returnShellEnv:
          haskellPackages.developPackage {
            inherit returnShellEnv;
            root = self;
            name = "template";
            source-overrides = {
              # here you can add source-overrides, for example:
              # inherit (inputs) aeson;
            };
            overrides = hself: hsuper: with pkgs.haskell.lib; {
              # Here you can override things, for example
              # http2 = dontCheck (hsuper.http2);
            };
            modifier = drv:
              with pkgs.haskell.lib;
              overrideCabal drv (drv:
                {
                  buildTools = (drv.buildTools or [ ]) ++ (with haskellPackages; [
                    # Add build tools here 
                    cabal-install
                    ghcid
                    haskell-language-server
                    retrie
                    hpack
                    fourmolu
                  ]);
                  testToolDepends = (drv.testTools or [ ]) ++ (with pkgs; [
                    # Add test tools here
                  ]);
                });
          };
      in
      {
        packages = {
          default = project false;
        };
        devShell = project true;
      });
}
