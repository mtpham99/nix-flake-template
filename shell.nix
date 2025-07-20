{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "";

  nativeBuildInputs = [ ];

  # Environment variables
  # NIX_ENFORCE_NO_NATIVE = 0

  shellHook = ''

  '';
}
