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

buildPythonPackage rec {
  pname = "aiortc";
  version = "1.14.0";

  pyproject = true;
  disabled = pythonOlder "3.10"; # requires python version >=3.10

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rcimes4QoIVyHliOBqADWO2Or19rYvCpU1j/RWKN12I=";
  };

  dependencies = [
    aioice
    av
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
