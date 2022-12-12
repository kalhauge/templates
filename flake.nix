{
  description = "Christian's collection of flake templates";

  outputs = { self }: {
    templates = {
      haskell = {
        path = ./haskell;
        description = "A good start for a haskell project";
      };
    };
  };

}
