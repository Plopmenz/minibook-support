{
  fetchFromGitHub,
  pkgs,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "minibook-support";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "petitstrawberry";
    repo = "minibook-support";
    tag = version;
    hash = "sha256-kg4s9J+YtszrUsCR0nEzHFSAoInecmDmTefcsOZr02c=";
  };

  nativeBuildInputs = [
    pkgs.gcc
    pkgs.makeWrapper
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp keyboardd/bin/keyboardd $out/bin/
    cp moused/bin/moused $out/bin/
    cp tabletmoded/bin/tabletmoded $out/bin/
  '';

  meta = {
    description = "Software for CHUWI MiniBook (8-inch) / MiniBook X (10-inch) / FreeBook N100 (14-inch) running Linux";
    homepage = "https://github.com/petitstrawberry/minibook-support";
    license = pkgs.lib.licenses.mit;
  };
}
