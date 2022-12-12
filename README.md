# Nix Templates


## Getting started

Install nix with flakes, follow the guide at https://nixos.org/download.html, 
then enable flakes by adding the following to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

Now you should be able to set up a new haskell system using:
```
nix flake init -t github:kalhauge/templates#<template-name>
```

Lookup the folder with the name for more instructions.

