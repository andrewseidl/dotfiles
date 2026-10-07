#!/usr/bin/env bash
# Verify pinned Intel and Apple Silicon macOS Starship artifacts install correctly.
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

docker run --rm \
    --platform linux/amd64 \
    --volume "$repo_root:/source:ro" \
    ubuntu:24.04 \
    bash -lc '
        set -Eeuo pipefail
        export DEBIAN_FRONTEND=noninteractive
        apt-get update -qq
        apt-get install --yes -qq git curl ca-certificates file >/dev/null
        mkdir -p /opt/homebrew/bin
        printf "#!/bin/sh\nexit 0\n" > /opt/homebrew/bin/security
        chmod +x /opt/homebrew/bin/security

        for arch in x86_64 arm64; do
            export HOME="/home/darwin-$arch"
            mkdir -p "$HOME/.zsh/plugins/zsh-syntax-highlighting" \
                "$HOME/.zsh/plugins/zsh-git-prompt" \
                "$HOME/.fzf/bin"
            git -C "$HOME/.zsh/plugins/zsh-syntax-highlighting" init -q
            git -C "$HOME/.zsh/plugins/zsh-git-prompt" init -q
            git -C "$HOME/.fzf" init -q
            touch "$HOME/.fzf/bin/fzf"
            chmod +x "$HOME/.fzf/bin/fzf"

            git clone -q https://github.com/andrewseidl/dotfiles.git "$HOME/.dotfiles"
            cp /source/init.sh "$HOME/.dotfiles/init.sh"
            DOTFILES_OS=Darwin STARSHIP_ARCH="$arch" bash "$HOME/.dotfiles/init.sh"

            case "$arch" in
                x86_64) file "$HOME/.local/bin/starship" | grep -Fq "Mach-O 64-bit x86_64 executable" ;;
                arm64) file "$HOME/.local/bin/starship" | grep -Fq "Mach-O 64-bit arm64 executable" ;;
            esac
        done
    '
