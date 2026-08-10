{
  lib,
  stdenv,
  fetchFromGitHub,
  libbfd,
  libelf,
  capstone,
  python3,
  # retdec,
}:
let
  pname = "wsolver";
  version = "1.0.0";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wsolver";
    tag = "v${version}";
    hash = "sha256-9PwhOKk9KA5O05LFFGtpqwhEyQBm4ff447BoD06RggU=";
  };

  buildInputs = [
    libbfd
    libelf
    capstone
    # retdec # TODO: Broken upstream https://github.com/NixOS/nixpkgs/issues/466575
    python3
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  installFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
    "REVNGDIR=$(out)/bin"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/etc
  '';

  postInstall = ''
      echo "s#python3#${lib.getExe python3}#"
    sed -i $out/etc/wsolver/wsolver.conf \
      -e "s#\# REVNG = /opt/revng/bin/revng#REVNG = $out/bin/revng-docker#" \
      -e "s#python3#${lib.getExe python3}#"
    mv $out/bin/revng $out/bin/revng-docker
  '';
    # TODO
    # -e "s#\# RETDEC = /opt/solution/tools/retdec/bin/retdec-decompiler#RETDEC = ${retdec}" \

  meta = {
    homepage = "https://github.com/endrazine/wsolver";
    description = "Find memory corruption vulnerabilities in stripped binaries — no source code required.";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "wsolve";
  };
}
