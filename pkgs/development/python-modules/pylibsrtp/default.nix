{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, setuptools
, srtp
, cffi
, openssl
}:

buildPythonPackage rec {
  pname = "pylibsrtp";
  version = "0.12.0";

  pyproject = true;
  disabled = pythonOlder "3.9" ; # requires python version >=3.9

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9cPA+2lU57t03H5jmDUnQMpnMn5nWaGZ/oUtvHuEuKw=";
  };

  dependencies = [
#    srtp
    cffi
  ];

  buildInputs = [
    openssl
    srtp
  ];

  build-system = [setuptools];

  meta = with lib; {
    description = "Python wrapper around the libsrtp library";
    homepage = "";
    license = licenses.bsd3;
    maintainers = [ maintainers.TheToddLuci0 ];
  };
}
