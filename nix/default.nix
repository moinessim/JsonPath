 with import ./nixpkgs.nix;
let 
  updateVsCodeSettingsFile=true;
  # ps1903 = import ./nixpkgs.nix;
  #VSCode Settings file
  #relative path from nix folder
  vscodeSettingsFile = builtins.toString ../.vscode/settings.json;
  updateVSCodeSettings =  
    builtins.toJSON (
      (builtins.fromJSON (builtins.readFile vscodeSettingsFile)) // 
      { 
        "java.home" = "${jdk}/"; 
      }
    );
  #uses jq to beautify the json coming out of builtins.toJSON
  vscodeUpdateSettingsCmd = lib.optionalString (lib.pathExists vscodeSettingsFile && updateVsCodeSettingsFile) ''
    echo '====================================='
    echo 'Updating ${vscodeSettingsFile} with JavaHome path'
    echo '${updateVSCodeSettings}' | ${jq}/bin/jq .  > ${vscodeSettingsFile}
  '';

in
stdenv.mkDerivation {
  name = "JsonPath";
  version = "2.4.0";
  src = ../.;
  buildInputs = [
    jdk
    gradle_4_10
  ];

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
    cp json-path/build/libs/json-path-2.4.0.jar $out
    cp json-path-assert/build/libs/json-path-assert-2.4.0.jar $out
    cp json-path-web-test/build/libs/json-path-web-test-2.4.0.jar $out
    echo "JsonPath jars can be found here:" $out
  '';

  shellHook=''
    ${vscodeUpdateSettingsCmd}
  '';
}

