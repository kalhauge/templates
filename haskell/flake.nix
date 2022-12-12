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
      url = "github:fourmolu/fourmolu/v0.10.1.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
        inherit (pkgs.haskell) lib;
        haskellPackages = pkgs.haskell.packages.ghc902;

        # The current version of fourmolu requires a some other versions of cabal-syntax
        # and ghc-lib-parser. 
        inherit (haskellPackages.override (_: {
          overrides = hself: hsuper:
            {
              Cabal-syntax = hself.callHackage "Cabal-syntax" "3.8.1.0" { };
              ghc-lib-parser = hself.callHackage "ghc-lib-parser" "9.4.2.20220822" { };
              fourmolu =
                lib.overrideCabal (hself.callCabal2nix "fourmolu" inputs.fourmolu { })
                  (drv: {
                    preCheck = drv.preCheck or "" + ''
                      export PATH="$PWD/dist/build/fourmolu:$PATH"
                    '';
                  });
            };
        })) fourmolu;

        project = returnShellEnv:
          haskellPackages.developPackage {
            inherit returnShellEnv;
            root = ./.;
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
                  buildTools =
                    (drv.buildTools or [ ])
                    ++ [ fourmolu ]
                    ++ (with haskellPackages; [
                      # Add build tools here 
                      cabal-install
                      ghcid
                      haskell-language-server
                      retrie
                      hpack
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
