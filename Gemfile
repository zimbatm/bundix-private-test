source "https://rubygems.org"
# This tries to fetch a github dependency using SSH
#
# The issue is that nix's fetchgit doesn't know how to use ssh or even get
# access to the ssh agent.
#
# This idea is to use bundix (and this nix-prefetch-git) to pre-populate the
# store.
gem "jsonpp", git: "git@github.com:zimbatm/jsonpp.git"

# Testing a dependency with a C extension
gem "eventmachine"
