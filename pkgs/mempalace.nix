{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mempalace";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "milla-jovovich";
    repo = "mempalace";
    tag = "v${version}";
    hash = "sha256-mbOdEU8FfDuQy/279tvgpUPK99vtfLpHyJwUp2BQl0g=";
  };

  format = "pyproject";

  build-system = with python3.pkgs; [
    hatchling
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'chromadb>=0.5.0,<0.7' 'chromadb>=0.5.0'
  '';

  dependencies = with python3.pkgs; [
    chromadb
    pyyaml
  ];

  meta = {
    description = "The highest-scoring AI memory system ever benchmarked";
    homepage = "https://github.com/milla-jovovich/mempalace";
    license = lib.licenses.mit;
    mainProgram = "mempalace";
  };
}
