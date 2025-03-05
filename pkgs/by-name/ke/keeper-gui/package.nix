{
  stdenv,
  fetchzip,
  lib,
  dpkg,
  autoPatchelfHook,
  libsecret,
  nss,
  gtk3,
  libXScrnSaver,
  alsa-lib,
  libdrm,
  vips,
  musl,
  mesa,
  libGL,
}:
let
  pname = "keeperpasswordmanager";
  version = "17.1.0";
in
stdenv.mkDerivation rec {
  inherit pname version;

  # Only .deb and .rpm are provided (no .zip or .tgz/tar.gz). We use the deb here.
  # Debs only come in amd64, RPMs in x86_64
  src = fetchzip {
    url = "https://www.keepersecurity.com/desktop_electron/Linux/repo/deb/${pname}_${version}_amd64.deb";
    hash = "sha256-vR6HcGmgDA9IzroCHfimGAA891mi9JO8LTrUVMTCRgY=";
    nativeBuildInputs = [ dpkg ];
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    libsecret
    gtk3
    libXScrnSaver
    nss
    alsa-lib
    libdrm
    vips
    mesa
    musl
    libGL
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp -R usr/share usr/lib $out/

    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/keeperpasswordmanager.desktop \
      --replace /lib/ $out/lib/

    ln -s $out/lib/keeperpasswordmanager/keeperpasswordmanager  $out/bin/keeperpasswordmanager

    runHook postInstall
  '';


  meta = with lib; {
    description = "Password manager with enteprise features";
    # Yoinked from the .deb
    longDescription = "Keeper is the world's #1 most downloaded password keeper and secure digital vault for protecting and managing your passwords and other secret information. Millions of people use Keeper to protect their most sensitive and private information.";
    homepage = "https://www.keepersecurity.com/";
    platforms = platforms.linux; # TODO: They distribute a windows and mac build, however I lack a mac to do any testing.
    license = licenses.unfree;
    maintainers = with maintainers; [
      TheToddLuci0
    ];
    mainProgram = "keeperpasswordmanager";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    downlaodPage = "https://www.keepersecurity.com/download.html";
  };

}
