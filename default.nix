{ stdenv, bundlerEnv, ruby_2_2, defaultGemConfig, openssl }:
stdenv.mkDerivation rec {
  name = "private-bundix";

  env = bundlerEnv {
    name = "private-bundix-gems";
    ruby = ruby_2_2;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    gemConfig = defaultGemConfig // {
      # Setting our own overrides. These should be imported into the
      # defaultGemConfig on the longer term.
      eventmachine = attrs: {
        buildInputs = [ openssl ];
      };
    };
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
