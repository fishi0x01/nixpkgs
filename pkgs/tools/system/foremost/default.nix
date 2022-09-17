{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "foremost";
  version = "1.5.7";

  src = fetchurl {
    sha256 = "0d2zxw0ijg8cd3ksgm8cf8jg128zr5x7z779jar90g9f47pm882h";
    url = "http://foremost.sourceforge.net/pkg/${pname}-${version}.tar.gz";
  };

  patches = [ ./makefile.patch ];

  # -fcommon: Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: api.o:(.bss+0xbdba0): multiple definition of `wildcard'; main.o:(.bss+0xbd760): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  makeFlags = [ "PREFIX=$(out)" ] ++ lib.optionals stdenv.isDarwin [ "mac" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  preInstall = ''
    mkdir -p $out/{bin,share/man/man8}
  '';

  meta = with lib; {
    description = "Recover files based on their contents";
    longDescription = ''
      Foremost is a console program to recover files based on their headers,
      footers, and internal data structures. Foremost can work on image files, such
      as those generated by dd, Safeback, Encase, etc, or directly on a drive.
      The headers and footers can be specified by a configuration file or you can
      use command line switches to specify built-in file types. These built-in types
      look at the data structures of a given file format allowing for a more
      reliable and faster recovery.
    '';
    homepage = "http://foremost.sourceforge.net/";
    license = licenses.publicDomain;
    maintainers = [ maintainers.jiegec ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
