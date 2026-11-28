{
  lib,
  buildPythonPackage,
  isPyPy,
  distlib,
  fetchFromGitHub,
  filelock,
  flaky,
  hatch-vcs,
  hatchling,
  packaging,
  platformdirs,
  pytest-freezer,
  pytest-mock,
  pytestCheckHook,
  python-discovery,
  time-machine,
  versionCheckHook,
  hatch-fancy-pypi-readme,
  python-sbom,
  uv-build,
  scikit-build-core,
}:

buildPythonPackage ( finalAttrs: {
  pname = "virtualenv";
  version = "21.15.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "virtualenv";
    tag = finalAttrs.version;
    hash = "sha256-coWSoftk7Ku2YJFBqrdt6Po8g/08+MlBlNYrg63Xw+U=";
  };

  postPatch = ''
    substituteInPlace tests/unit/activation/test_bash.py \
      --replace-fail '"/bin/bash"' '_BASH'
  '';

  build-system = [
    hatch-vcs
    hatchling
    python-sbom
    hatch-fancy-pypi-readme
    uv-build
  ];

  dependencies = [
    distlib
    filelock
    packaging
    platformdirs
    python-discovery
  ];

  nativeCheckInputs = [
    flaky
    pytest-mock
    pytestCheckHook
    versionCheckHook
    finalAttrs.passthru.scikit-build-core-no-check
  ]
  ++ lib.optionals isPyPy [ pytest-freezer ]
  ++ lib.optionals (!isPyPy) [ time-machine ];

  disabledTestPaths = [
    # Ignore tests which require network access
    "tests/unit/create/test_creator.py"
    "tests/unit/create/via_global_ref/test_build_c_ext.py"
  ];

  disabledTests = [
    # Network access
    "test_seed_link_via_app_data"
    # Assumes FHS paths
    "test_bash_relocation_rejects_sourced_wrapper"
    # chmod fails in sandbox
    "test_app_data_setgid_keeps_group_write"
  ]
  ++ lib.optionals isPyPy [
    # encoding problems
    "test_bash"
    # permission error
    "test_can_build_c_extensions"
    # fails to detect pypy version
    "test_discover_ok"
    # type error
    "test_fallback_existent_system_executable"
  ];

  pythonImportsCheck = [ "virtualenv" ];

  passthru = {
    # FIXME this doesn't work weeeeee
    # scikit-build-core depends on virtualenv
    # venv -> sbom -> scikit = infinite recursion
    scikit-build-core-no-check = scikit-build-core.overridePythonAttrs {
      doCheck=false;
    };
  };

  meta = {
    description = "Tool to create isolated Python environments";
    mainProgram = "virtualenv";
    homepage = "https://virtualenv.pypa.io/en/latest/";
    changelog = "https://github.com/pypa/virtualenv/blob/${finalAttrs.version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
