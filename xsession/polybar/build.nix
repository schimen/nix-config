{ pkgs ? import <nixpkgs> {} }:

with pkgs;
callPackage ./polybar-scripts.nix {}

