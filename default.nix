{ stdenv, bundlerEnv, ruby_2_2 }:
stdenv.mkDerivation rec {
  name = "private-bundix";

  env = bundlerEnv {
    name = "private-bundix-gems";
    ruby = ruby_2_2;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  src = ./.;

  buildInputs = [ env.ruby env.bundler ];

  dontStrip = true;
  dontPatchELF = true;
  dontGzipMan = true;

  configurePhase = ''
    export HOME=$PWD
    export GEM_HOME=${env}/${env.ruby.gemPath}
    export PATH=${env}/bin:$PATH
    '';

  buildPhase = ''
    #rake --trace assets:precompile RAILS_ENV=production
  '';

  installPhase = ''
    cp -r . $out
  '';

  passthru = {
    bundler = env.bundler;
    gemHome = "${env}/${env.ruby.gemPath}";
    ruby = env.ruby;
  };
}
