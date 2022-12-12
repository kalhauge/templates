# Your new Haskell Project

## On first commit

Change the default values of things in `flake.nix` and in `package.yaml`, now 
you need to run, the following to command to get started.
```
nix develop -c hpack
```

After this the project should run and compile with `cabal`.

## Developing

Running `nix develop` should get you into a developing shell, from which you have most development
tools implemented.

```
nix develop 
```

Most notable is `hoogle`, `hlint`, `haskell-language-server`, and `fourmolu` installed.

### Compiling and Testing

```
nix develop -c cabal test
```

### Feedback loop

Simply run, ghcid in a terminal and it will automatically recompile and test your packages on each
run. Like this: 

```
nix develop -c ghcid -r
```

### Hoogle

To get hoogle up and running, run the following:

```
nix develop -c hoogle server --local
```
