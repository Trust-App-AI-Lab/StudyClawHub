#!/usr/bin/env bash
set -euo pipefail

OWNER="${STUCLAW_BETA_OWNER:-Trust-App-AI-Lab}"
REPO="${STUCLAW_BETA_REPO:-stuclaw-desktop}"
HOSTNAME="${STUCLAW_BETA_HOSTNAME:-github.com}"

log() {
  printf '%s\n' "==> $*"
}

warn() {
  printf '%s\n' "Warning: $*" >&2
}

die() {
  printf '%s\n' "Error: $*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

have_tty() {
  [[ -r /dev/tty && -w /dev/tty ]]
}

prompt_yes_no() {
  local prompt="$1"
  local answer=""
  if ! have_tty; then
    return 1
  fi
  printf '%s [y/N] ' "$prompt" > /dev/tty
  IFS= read -r answer < /dev/tty || answer=""
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

load_homebrew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_homebrew() {
  command_exists curl || die "Install curl, then rerun this script."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_homebrew_shellenv
}

install_gh() {
  case "$(uname -s)" in
    Darwin)
      load_homebrew_shellenv
      if ! command_exists brew; then
        if prompt_yes_no "Install Homebrew to install GitHub CLI?"; then
          install_homebrew
        else
          die "Install GitHub CLI from https://cli.github.com/, then rerun."
        fi
      fi
      brew install gh
      ;;
    Linux)
      if command_exists brew; then
        brew install gh
      else
        die "Install GitHub CLI from https://cli.github.com/, then rerun."
      fi
      ;;
    *)
      die "Unsupported OS. Install GitHub CLI manually, then rerun."
      ;;
  esac
}

ensure_gh() {
  if command_exists gh; then
    log "GitHub CLI found: $(command -v gh)"
    return 0
  fi
  warn "GitHub CLI was not found."
  if prompt_yes_no "Install GitHub CLI now?"; then
    install_gh
  else
    die "Install GitHub CLI, then rerun."
  fi
  command_exists gh || die "GitHub CLI is still not available after install."
}

ensure_gh_auth() {
  if gh auth status --hostname "$HOSTNAME" >/dev/null 2>&1; then
    log "GitHub CLI authenticated for $HOSTNAME."
    gh auth setup-git --hostname "$HOSTNAME"
    return 0
  fi
  if ! have_tty; then
    die "GitHub login requires an interactive terminal."
  fi
  log "Starting GitHub login."
  gh auth login --hostname "$HOSTNAME" --git-protocol https --scopes repo < /dev/tty > /dev/tty 2>&1
  gh auth setup-git --hostname "$HOSTNAME"
}

decode_base64() {
  if base64 --decode >/dev/null 2>&1 <<<"YQ=="; then
    base64 --decode
  else
    base64 -D
  fi
}

fetch_private_installer() {
  local out="$1"
  if ! gh api "repos/$OWNER/$REPO/contents/install.sh" --jq .content | decode_base64 > "$out"; then
    die "Could not fetch private installer. Make sure your GitHub invitation has been accepted."
  fi
  chmod +x "$out"
}

main() {
  local installer=""
  installer="$(mktemp "${TMPDIR:-/tmp}/stuclaw-install.XXXXXX.sh")"
  trap 'rm -f "$installer"' EXIT

  log "StuClaw Desktop beta installer"
  ensure_gh
  ensure_gh_auth
  fetch_private_installer "$installer"
  bash "$installer" "$@"
}

main "$@"
