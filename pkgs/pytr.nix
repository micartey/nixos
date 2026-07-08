{
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  lib,
  stdenv,
  python3Packages,
  versionCheckHook,
  playwright-driver,
}:

python3Packages.buildPythonApplication rec {
  pname = "pytr";
  version = "0.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytr-org";
    repo = "pytr";
    rev = "24163dce3c88914fdb44ee6ce30cf3db1051b1d3";
    hash = "sha256-JZ6+imqe9hdnRn4geoeE0B3XItSXcA7+08MIiGttddM=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-babel
  ];

  dependencies = with python3Packages; [
    babel
    certifi
    coloredlogs
    cryptography
    curl-cffi
    packaging
    pathvalidate
    playwright
    pygments
    requests-futures
    shtab
    websockets
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd pytr \
        --bash <($out/bin/pytr completion bash) \
        --zsh <($out/bin/pytr completion zsh)
    ''
    + ''
      wrapProgram $out/bin/pytr \
        --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
        --set PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS true
    '';

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [ "pytr" ];

  meta = {
    changelog = "https://github.com/pytr-org/pytr/commit/${src.rev}";
    description = "Use TradeRepublic in terminal and mass download all documents";
    homepage = "https://github.com/pytr-org/pytr";
    license = lib.licenses.mit;
    mainProgram = "pytr";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
