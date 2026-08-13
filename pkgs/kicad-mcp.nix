{
  buildNpmPackage,
  fetchFromGitHub,
  fetchPypi,
  lib,
  makeWrapper,
  nodejs,
  python3,
  ...
}:
let
  kicad-skip = python3.pkgs.buildPythonPackage rec {
    pname = "kicad-skip";
    version = "0.2.5";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-3GtHIV2h6C8syFZ/Dx6OWsgpf14ZQdlnGS4EM4DgjIM=";
    };

    propagatedBuildInputs = [ python3.pkgs.sexpdata ];
    build-system = [ python3.pkgs.setuptools ];
  };

  python = python3.withPackages (ps: [
    ps.cairosvg
    ps.colorlog
    ps.kicad-python
    ps.pillow
    ps.pydantic
    ps.python-dotenv
    ps.requests
    ps.sexpdata
    kicad-skip
  ]);
in
buildNpmPackage rec {
  pname = "kicad-mcp";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "mixelpixx";
    repo = "KiCAD-MCP-Server";
    rev = "d35dd01342c2ee6adbcd4522c60e0a8ac339f35f";
    hash = "sha256-nuD68cj7AGXiO5fEfNfNvgsTiJaJlW69Mzdl31PlbWk=";
  };

  npmDepsHash = "sha256-QlrIhfin80CpTaEKs7ujqW4m1rF/ENUY0aEdD8SBMHc=";

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    cat > python/pcbnew.py <<'EOF'
    """Fail only when legacy SWIG backend is called under KiCad 10."""

    class _Unavailable:
        def __init__(self, *_args, **_kwargs):
            raise RuntimeError("pcbnew is unavailable; use KiCad IPC")

        @classmethod
        def __class_getitem__(cls, _item):
            return cls

        def __getattr__(self, _name):
            return type(self)

    def __getattr__(_name):
        return _Unavailable
    EOF

    substituteInPlace src/server.ts \
      --replace-fail \
        'if (pythonExecutableAvailable && existsSync(this.kicadScriptPath)) {' \
        'if (process.env.KICAD_BACKEND != "ipc" && pythonExecutableAvailable && existsSync(this.kicadScriptPath)) {'

    substituteInPlace python/kicad_api/ipc_backend.py \
      --replace-fail \
        'socket_paths_to_try.append("ipc:///tmp/kicad/api.sock")  # Linux default' \
        'socket_paths_to_try.extend(
                        [ f"ipc://{path}" for path in sorted(Path("/tmp/kicad").glob("api*.sock"), key=lambda path: path.stat().st_mtime, reverse=True) ]
                    )'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/kicad-mcp $out/bin
    cp -r dist python config package.json node_modules $out/lib/kicad-mcp/

    makeWrapper ${nodejs}/bin/node $out/bin/kicad-mcp \
      --add-flags $out/lib/kicad-mcp/dist/index.js \
      --prefix PATH : ${lib.makeBinPath [ python ]} \
      --prefix PYTHONPATH : $out/lib/kicad-mcp/python \
      --set KICAD_BACKEND ipc

    runHook postInstall
  '';

  meta = {
    description = "Model Context Protocol server for KiCad";
    homepage = "https://github.com/mixelpixx/KiCAD-MCP-Server";
    license = lib.licenses.mit;
    mainProgram = "kicad-mcp";
    platforms = lib.platforms.linux;
  };
}
