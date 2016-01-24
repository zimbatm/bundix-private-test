{ nixpkgs ? import <nixpkgs> {}, stdenv ? nixpkgs.stdenv }:
let
  package = nixpkgs.callPackage ./default.nix {};
in
stdenv.mkDerivation rec {
  name = "private-bundix-shell";
  env = package.env;
  buildInputs = package.buildInputs;
  shellHook = ''
    export HOME=$PWD
    export GEM_HOME=${env}/${env.ruby.gemPath}
    export PATH=${env}/bin:${env.bundler}/bin:$PATH
  '';
}
