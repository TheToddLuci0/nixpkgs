{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libx11,
  wayland,
  libxkbcommon,
  writeScript,
  ...
}:
stdenv.mkDerivation rec {
  pname = "shodan-terminal";
  version = "0.14.1";

  src = fetchurl {
    url = "https://terminal.shodan.io/releases/${version}/shodan-terminal-linux-${{
      "x86_64-linux" = "x86_64";
      "aarch64-linux" = "arm64";
    }.${stdenv.hostPlatform.system}
  }.deb";
    sha256 = "sha256-nDlVxQ4SmVSKb5Q1A7n/cSC7NQ3tim96YYtL3Fi0VF4=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
  runtimeDependencies = [
    libx11
    wayland
    libxkbcommon
  ];
  unpackPhase = "dpkg -x $src .";
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    mv usr/bin $out/bin
    mv usr/share $out/share
  '';

  passthru.updateScript = writeScript "update-shodan-terminal" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -eu -o pipefail
    version="$(curl -s https://terminal.shodan.io/releases.json | jq '.latest' -r)"
    update-source-version shodan-terminal "$version"
  '';

  meta = {
    description = "Cross-platform desktop application to access the entire Shodan platform using an API key";
    homepage = "https://terminal.shodan.io/";
    mainProgram = "shodan-terminal";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [lib.maintainers.TheToddLuci0];
  };

}
