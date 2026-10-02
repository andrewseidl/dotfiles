#!/usr/bin/env bash
# Verify that a missing CA bundle is repaired even when Git and Curl exist.
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

docker run --rm \
    --volume "$repo_root:/source:ro" \
    ubuntu:24.04 \
    bash -lc '
        export DEBIAN_FRONTEND=noninteractive
        export HOME=/home/dotfiles
        apt-get update -qq
        apt-get install --yes -qq git curl ca-certificates >/dev/null

        mv /etc/ssl/certs/ca-certificates.crt /tmp/ca-certificates.crt
        mkdir -p "$HOME/.zsh/plugins/zsh-syntax-highlighting" \
            "$HOME/.zsh/plugins/zsh-git-prompt" \
            "$HOME/.fzf/bin"
        git -C "$HOME/.zsh/plugins/zsh-syntax-highlighting" init -q
        git -C "$HOME/.zsh/plugins/zsh-git-prompt" init -q
        git -C "$HOME/.fzf" init -q
        touch "$HOME/.fzf/bin/fzf"
        chmod +x "$HOME/.fzf/bin/fzf"

        bash /source/init.sh
        test -r /etc/ssl/certs/ca-certificates.crt
        test -d "$HOME/.dotfiles/.git"
    '
