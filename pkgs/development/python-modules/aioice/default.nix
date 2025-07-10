{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools

# Python deps
, dnspython
, ifaddr
}:

buildPythonPackage rec {
  pname = "aioice";
  version = "0.10.1";

  pyproject = true;
  disabled = pythonOlder "3.9"; # requires python version >=3.9

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XI4UIhA0SNFxklxnj7OXleX+E9eRCL67AKp1qJnCCUo=";
  };

  dependencies = [
    dnspython
    ifaddr
  ];

  build-system = [setuptools];

  meta = with lib; {
    description = "An implementation of Interactive Connectivity Establishment (RFC 5245)";
    homepage = "";
    license = licenses.bsd3;
    maintainers = [ maintainers.TheToddLuci0 ];
  };
}
