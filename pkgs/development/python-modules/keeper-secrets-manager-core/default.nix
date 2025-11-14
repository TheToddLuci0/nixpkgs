{ lib
, buildPythonPackage
, fetchPypi
, setuptools

# Python deps
, requests
, cryptography
, importlib-metadata
, pythonOlder
}:

buildPythonPackage rec {
  pname = "keeper-secrets-manager-core";
  version = "17.0.0";

  pyproject = true;
  disabled = pythonOlder "3.6"; # requires python version >=3.6

  src = fetchPypi {
    inherit version;
    pname = "keeper_secrets_manager_core";
    sha256 = "sha256-+CHRFLROzZkocPRmHR2qXFCQHUq8xtUsN5JsNyOW0xw=";
  };

  build-system = [setuptools];

  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # cryptography>=39.0.1
  dependencies = [
    requests
    cryptography
    importlib-metadata
  ];

  meta = with lib; {
    description = "Keeper Secrets Manager for Python 3";
    homepage = "https://github.com/Keeper-Security/secrets-manager";
    license = licenses.mit;
    maintainers = [ maintainers.TheToddLuci0 ];
  };
}
