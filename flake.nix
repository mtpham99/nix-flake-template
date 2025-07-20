{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      pkgsFor = system: import nixpkgs { inherit system; };
      forAllSystems = fn: nixpkgs.lib.genAttrs supportedSystems (system: fn (pkgsFor system));

      treefmtEvalFor = system: treefmt-nix.lib.evalModule (pkgsFor system) ./treefmt.nix;
    in
    {
      # `nix run`
      packages = forAllSystems (pkgs: {
        # default = ;
      });

      # `nix develop`
      devShells = forAllSystems (pkgs: {
        default = import ./shell.nix { inherit pkgs; };
      });

      # `nix flake check`
      checks = forAllSystems (pkgs: {
        formatting = (treefmtEvalFor pkgs.system).config.build.check self;
        # default = ;
      });

      # `nix fmt`
      formatter = forAllSystems (pkgs: (treefmtEvalFor pkgs.system).config.build.wrapper);
    };
}
