{
  lib,
  async-timeout,
  buildPythonPackage,
  click,
  click-log,
  fetchFromGitHub,
  pure-pcapy3,
  pyserial-asyncio,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.44.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    tag = version;
    hash = "sha256-9CuZGorTqay09ZHrUDoorYew8vvDV6pyxMuik7/QKJ4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    click
    click-log
    pure-pcapy3
    pyserial-asyncio
    voluptuous
    zigpy
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [ "bellows" ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    mainProgram = "bellows";
  };
}
