{
  description = "Insert description here";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:NixOs/nixpkgs/nixpkgs-unstable";
      inputs.nixpkgs.follow = "nixpkgs";
    };
    fourmolu = {
      url = "github:fourmolu/fourmolu/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, fourmolu }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
        haskellPackages = pkgs.haskell.packages.ghc902;
        project = returnShellEnv:
          haskellPackages.developPackage {
            inherit returnShellEnv;
            root = self;
            name = throw "Insert name here!";
            source-overrides = {
              # here you can add source-overrides, for example:
              inherit (inputs) fourmolu;
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
