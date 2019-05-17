with import ./nixpkgs.nix;
import ./default.nix rec {
  additionalBuildInputs = [
      figlet
    ];
  shellHook = ''
    figlet "jsonPath prod"
  '';
}
