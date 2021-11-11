#!/bin/sh

set -x

nix_store_path="$(nix-store --add en.st-stm32cubeide_1.7.0_10852_20210715_0634_amd64.sh_v1.7.0.zip)"
nix-store -r "$nix_store_path" --add-root ./root-name --indirect
