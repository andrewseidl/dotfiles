#!/usr/bin/env bash
# Verify init.sh refuses to replace an existing non-Git dotfiles path.
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

        mkdir -p "$HOME/.zsh/plugins/zsh-syntax-highlighting" \
            "$HOME/.zsh/plugins/zsh-git-prompt" \
            "$HOME/.fzf/bin" \
            "$HOME/.dotfiles"
        git -C "$HOME/.zsh/plugins/zsh-syntax-highlighting" init -q
        git -C "$HOME/.zsh/plugins/zsh-git-prompt" init -q
        git -C "$HOME/.fzf" init -q
        touch "$HOME/.fzf/bin/fzf"
        chmod +x "$HOME/.fzf/bin/fzf"

        if bash /source/init.sh > /tmp/init.out 2>&1; then
            echo "init.sh unexpectedly accepted an existing non-Git dotfiles path" >&2
            exit 1
        fi
        grep -F "Refusing to replace existing non-Git path: $HOME/.dotfiles" /tmp/init.out
    '
