#!/usr/bin/env bash
# Verify the ARM64 Starship artifact is selected and checksum-verified.
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

docker run --rm \
    --platform linux/amd64 \
    --volume "$repo_root:/source:ro" \
    ubuntu:24.04 \
    bash -lc '
        set -Eeuo pipefail
        export DEBIAN_FRONTEND=noninteractive
        export HOME=/home/dotfiles
        apt-get update -qq
        apt-get install --yes -qq git curl ca-certificates >/dev/null

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
        STARSHIP_ARCH=aarch64 bash "$HOME/.dotfiles/init.sh"

        # ELF e_machine is the byte sequence 183, 0 for AArch64.
        test "$(od -An -tu1 -j 18 -N 2 "$HOME/.local/bin/starship" | xargs)" = "183 0"
    '
