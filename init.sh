#!/usr/bin/env bash

set -Eeuo pipefail

PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
export PATH

DFDIR="$HOME/.dotfiles"

has_ca_certificates() {
    [[ -r /etc/ssl/certs/ca-certificates.crt ||
       -r /etc/pki/tls/certs/ca-bundle.crt ||
       -r /etc/ssl/cert.pem ]] || command -v security >/dev/null
}

install_dependencies() {
    if git --version >/dev/null 2>&1 && curl --version >/dev/null 2>&1 && has_ca_certificates; then
        return
    fi

    local -a privileged
    if (( EUID == 0 )); then
        privileged=()
    elif command -v sudo >/dev/null; then
        privileged=(sudo)
    else
        echo "Git and curl are required; rerun with sudo available." >&2
        return 1
    fi

    if command -v apt-get >/dev/null; then
        "${privileged[@]}" apt-get update
        "${privileged[@]}" apt-get install --yes git curl
        if ! has_ca_certificates; then
            "${privileged[@]}" apt-get install --yes --reinstall ca-certificates
        fi
    elif command -v pacman >/dev/null; then
        "${privileged[@]}" pacman --sync --refresh --noconfirm git curl ca-certificates
    else
        echo "Git and curl are required; install them and rerun." >&2
        return 1
    fi
}

install_starship() {
    local destination="$HOME/.local/bin/starship"
    if [[ -x $destination ]]; then
        return
    fi

    local machine target checksum
    machine=${STARSHIP_ARCH:-$(uname -m)}
    case "$machine" in
        x86_64|amd64)
            target='starship-x86_64-unknown-linux-gnu.tar.gz'
            checksum='321f0dd7af8340a5f2e6a8fec6538a04f617486f9ec70d878f91c09cd8deef22'
            ;;
        aarch64|arm64)
            target='starship-aarch64-unknown-linux-musl.tar.gz'
            checksum='dc30189378d2f2e287384e8a692d3f95ad1df64cf0e8c36aa9201516028aed6b'
            ;;
        armv7l|armv6l)
            target='starship-arm-unknown-linux-musleabihf.tar.gz'
            checksum='c7bd93b1cfb87dd4e531d100b4f87cb77eee9eb2982d9428940bc006db4ab689'
            ;;
        *)
            echo "Unsupported Starship architecture: $machine" >&2
            return 1
            ;;
    esac

    local temporary archive staged
    temporary=$(mktemp -d) || {
        echo "Unable to create a temporary directory for Starship." >&2
        return 1
    }
    archive="$temporary/$target"
    staged=''
    trap 'rm -rf "$temporary"; rm -f "$staged"' RETURN
    if ! curl --fail --location --retry 3 --retry-all-errors \
        --connect-timeout 10 --max-time 300 \
        "https://github.com/starship/starship/releases/download/v1.26.0/$target" \
        --output "$archive"; then
        echo "Unable to download Starship." >&2
        return 1
    fi
    if ! printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check --status; then
        echo "Starship checksum verification failed." >&2
        return 1
    fi
    if ! mkdir -p "$(dirname "$destination")"; then
        echo "Unable to create the Starship installation directory." >&2
        return 1
    fi
    if ! tar --extract --gzip --file "$archive" --directory "$temporary"; then
        echo "Unable to extract Starship." >&2
        return 1
    fi
    staged=$(mktemp "${destination}.tmp.XXXXXX") || {
        echo "Unable to stage Starship for installation." >&2
        return 1
    }
    if ! install -m 0755 "$temporary/starship" "$staged" || ! mv -f "$staged" "$destination"; then
        echo "Unable to install Starship." >&2
        return 1
    fi
    staged=''
}

clone_repository() {
    local destination=$1
    shift
    CLONE_REPOSITORY_CREATED=0

    if [[ -e $destination || -L $destination ]]; then
        if git -C "$destination" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            return
        fi
        echo "Refusing to replace existing non-Git path: $destination" >&2
        return 1
    fi

    mkdir -p "$(dirname "$destination")"

    local attempt temporary
    for attempt in 1 2 3; do
        temporary=$(mktemp -d "${destination}.tmp.XXXXXX")
        if git clone "$@" "$temporary/repository"; then
            mv "$temporary/repository" "$destination"
            rmdir "$temporary"
            CLONE_REPOSITORY_CREATED=1
            return
        fi
        rm -rf "$temporary"
        echo "Clone attempt $attempt/3 failed; retrying." >&2
        sleep "$attempt"
    done

    echo "Unable to clone after 3 attempts: $*" >&2
    return 1
}

install_dependencies
install_starship

ZSHL="$HOME/.zsh/plugins/zsh-syntax-highlighting"
clone_repository "$ZSHL" https://github.com/zsh-users/zsh-syntax-highlighting.git

ZSHP="$HOME/.zsh/plugins/zsh-git-prompt"
clone_repository "$ZSHP" https://github.com/olivierverdier/zsh-git-prompt.git

FZF="$HOME/.fzf"
clone_repository "$FZF" --depth 1 https://github.com/junegunn/fzf.git
if [[ ! -x "$FZF/bin/fzf" ]]; then
    "$FZF/install" --all
fi

clone_repository "$DFDIR" https://github.com/andrewseidl/dotfiles.git

pushd "$DFDIR" >/dev/null
if (( ! CLONE_REPOSITORY_CREATED )); then
    if git diff --quiet && git diff --cached --quiet; then
        git pull --quiet --ff-only
    else
        git status --short
    fi
fi

while IFS= read -r -d '' dotfile; do
    homefile="$HOME/$(basename "$dotfile")"
    if [[ -e $homefile || -L $homefile ]]; then
        if [[ "$dotfile" != "$(readlink "$homefile" 2>/dev/null || true)" ]]; then
            backup="${homefile}.bak-$(date +%Y%m%d)"
            backup_number=1
            while [[ -e $backup || -L $backup ]]; do
                backup="${homefile}.bak-$(date +%Y%m%d)-${backup_number}"
                ((backup_number++))
            done
            mv "$homefile" "$backup"
        fi
    fi
    ln -sfn "$dotfile" "$HOME/"
done < <(find "$PWD/home" -maxdepth 1 -mindepth 1 -print0)

popd >/dev/null
