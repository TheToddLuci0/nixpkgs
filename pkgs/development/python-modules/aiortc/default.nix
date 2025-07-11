{ lib
, buildPythonPackage
, fetchPypi
, setuptools

, libopus
, libvpx

# Python deps
, aioice
, av
, cryptography
, google-crc32c
, pylibsrtp
, pyopenssl
, pyee
, pythonOlder
}:

let
  av_13_1_0 = av.overridePythonAttrs (old: rec {
    version = "13.1.0";
    src = old.src.override {
      hash = "sha256-x2a9SC4uRplC6p0cD7fZcepFpRidbr6JJEEOaGSWl60=";
      tag = "v${version}";
    };
  });
in
buildPythonPackage rec {
  pname = "aiortc";
  version = "1.10.1";

  pyproject = true;
  disabled = pythonOlder "3.9"; # requires python version >=3.9

  src = fetchPypi {
    inherit pname version;
    sha256 = "64926ad86bde20c1a4dacb7c3a164e57b522606b70febe261fada4acf79641b5";
  };

  dependencies = [
    aioice
    av_13_1_0
    cryptography
    google-crc32c
    pyee
    pylibsrtp
    pyopenssl
  ];

  buildInputs = [
    libopus
    libvpx
  ];

  build-system = [setuptools];

  meta = with lib; {
    description = "An implementation of WebRTC and ORTC";
    homepage = "";
    license = licenses.bsd3;
    maintainers = [ maintainers.TheToddLuci0 ];
  };
}
