with import ./nixpkgs.nix;
let

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
  vscodeUpdateSettingsCmd = lib.optionalString (lib.pathExists vscodeSettingsFile) ''
    echo '====================================='
    echo 'Updating ${vscodeSettingsFile} with JavaHome path'
    echo '${updateVSCodeSettings}' | ${jq}/bin/jq .  > ${vscodeSettingsFile}
  '';
in
import ./default.nix {
  additionalBuildInputs = [
      figlet
    ];
  shellHook = '' 
    figlet "JsonPath"
    ${vscodeUpdateSettingsCmd}
  '';
}