{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# Build system
, setuptools
, setuptools-scm

# Python deps
, asciitree
, bcrypt
, colorama
, cryptography
, fido2
, flask
, flask-limiter
, keeper-secrets-manager-core
, prompt-toolkit
, protobuf
, pycryptodomex
, pyngrok
, pyperclip
, pysocks
, python-dotenv
, requests
, tabulate
, websockets
, aiortc
, pydantic
, fpdf2
, psutil

# Tests
, pytest
, testfixtures

, pikepdf
}:
let
  fido2_2_0_0 = fido2.overridePythonAttrs (old: rec {
    version = "2.0.0";
    src = old.src.override {
      inherit version;
      hash = "sha256-MGHNBec7Og72r8O4A9V8gmqi1qlzLRar1ydzYfWOeWQ=";
    };
# The tests will wipe any TPM's they touch
    doCheck = false;
  });
  # Stopgap until someone updates FPDF2
  # https://github.com/NixOS/nixpkgs/pull/404863
  fpdf2_2_8_3 = fpdf2.overridePythonAttrs (old: rec {
    version = "2.8.3";
    src = old.src.override {
      hash = "sha256-uLaVRseakLg7Q9QO4F6BM7vQIFeA44ry8cqDfas8oMA=";
      tag = version;
    };
    nativeCheckInputs = old.nativeCheckInputs ++ [pikepdf];
  });
in
buildPythonPackage rec {
  pname = "keepercommander";
  version = "17.1.3";

  disabled = pythonOlder "3.7"; # requires python version >=3.7
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XOzCcB1iPQkPg+pPobX9P+iP+O6dzL+pmutodfdp0QM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # cryptography>=38.0.3
  # keeper-secrets-manager-core>=16.2.0
  # protobuf>=3.18.0
  # pycryptodomex>=3.7.2
  # requests; python_version < "3.7"
  # requests>=2.30.0; python_version >= "3.7"
  # aiortc; python_version >= "3.8" and python_version < "3.13"
  # pydantic>=2.6.4; python_version >= "3.8"
  # # Extra packages (may not be necessary)
  # pytest; extra == "test"
  # testfixtures; extra == "test"
  dependencies = [
    asciitree
    bcrypt
    colorama
    cryptography
    fido2_2_0_0
    flask
    flask-limiter
    keeper-secrets-manager-core
    prompt-toolkit
    protobuf
    psutil
    pycryptodomex
    pyngrok
    pyperclip
    pysocks
    python-dotenv
    requests
    tabulate
    websockets
    aiortc
    pydantic
    fpdf2_2_8_3
  ];

  nativeCheckInputs = [
    pytest
    testfixtures
  ];

  meta = with lib; {
    description = "Keeper Commander for Python 3";
    homepage = "https://keepersecurity.com/";
    license = licenses.mit;
    maintainers = [ maintainers.TheToddLuci0 ];
  };
}
