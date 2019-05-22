 {
   json-path?true, json-path-assert?true, json-path-web-test?true
   ,additionalBuildInputs?[]
   ,shellHook?""
   ,pkgs?import ./nixpkgs.nix
 }:
with pkgs;
stdenv.mkDerivation {
  name = "JsonPath";
  version = "2.4.0";
  src = ../.;
  buildInputs = [
    jdk
    gradle_4_10
  ]++additionalBuildInputs;

  buildPhase = ''
    echo "Temp folder: " $(pwd)
    echo "Building JsonPath..."
    rm -rf json-path/build
    rm -rf json-path-assert/build
    rm -rf json-path-web-test/build
    gradle -g $(pwd) jar
  '';
  installPhase = ''
    echo "Installing JsonPath..."
    mkdir -p $out
    ''
    + lib.optionalString json-path ''cp json-path/build/libs/json-path-2.4.0.jar $out
    ''
    + lib.optionalString json-path-assert ''cp json-path-assert/build/libs/json-path-assert-2.4.0.jar $out
    ''
    + lib.optionalString json-path-web-test ''cp json-path-web-test/build/libs/json-path-web-test-2.4.0.jar $out
    '';
  
  inherit shellHook;
}

