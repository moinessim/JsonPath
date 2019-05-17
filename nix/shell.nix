with import ./nixpkgs.nix;
import ./default.nix {
  additionalBuildInputs = [
      figlet
    ];
  shellHook = ''
    figlet "JsonPath"
  '';
}
