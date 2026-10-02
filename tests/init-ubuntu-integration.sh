#!/usr/bin/env bash
# Verify a single init.sh run completes on a bare Ubuntu base image.
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
if (( $# )); then
    images=("$@")
else
    images=(ubuntu:24.04 ubuntu:26.04 ubuntu:26.10 archlinux:latest)
fi

for image in "${images[@]}"; do
    docker run --rm \
        --platform "${TEST_PLATFORM:-linux/amd64}" \
        --volume "$repo_root:/source:ro" \
        "$image" \
        bash -lc '
            set -Eeuo pipefail
            export DEBIAN_FRONTEND=noninteractive
            export HOME=/home/dotfiles
            mkdir -p "$HOME" /usr/local/bin
            printf "%s\n" \
                "#!/usr/bin/env bash" \
                "if [[ \$1 == clone && ! -e /tmp/git-clone-failed-once ]]; then" \
                "    touch /tmp/git-clone-failed-once" \
                "    exit 1" \
                "fi" \
                "exec /usr/bin/git \"\$@\"" \
                > /usr/local/bin/git
            chmod +x /usr/local/bin/git

            bash /source/init.sh

            test -f /tmp/git-clone-failed-once
            test -d "$HOME/.zsh/plugins/zsh-syntax-highlighting/.git"
            test -d "$HOME/.zsh/plugins/zsh-git-prompt/.git"
            test -x "$HOME/.fzf/bin/fzf"
            test -d "$HOME/.dotfiles/.git"
            test -x "$HOME/.local/bin/starship"
            "$HOME/.local/bin/starship" --version | grep -Fx "starship 1.26.0"
            test -L "$HOME/.vimrc"
        '
done
