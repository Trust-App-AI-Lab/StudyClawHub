#!/usr/bin/env bash
set -euo pipefail

OWNER="${STUCLAW_BETA_OWNER:-Trust-App-AI-Lab}"
REPO="${STUCLAW_BETA_REPO:-stuclaw-desktop}"
HOSTNAME="${STUCLAW_BETA_HOSTNAME:-github.com}"
INSTALLER_TMP=""
YES=0
NO_PROMPT=0
RUN_GH_INSTALL=1
RUN_GH_AUTH=1
FORWARD_ARGS=()
FORWARD_COUNT=0

usage() {
  cat <<'EOF'
StuClaw Desktop bootstrap installer

Usage:
  curl -fsSL https://trust-app-ai-lab.github.io/StudyClawHub/install-stuclaw-desktop.sh | bash
  bash install-stuclaw-desktop.sh [options]

Options:
  --dir PATH       Forward install directory to the private installer
  --no-gh-install  Do not install GitHub CLI automatically
  --no-gh-auth     Do not start GitHub login automatically
  -y, --yes        Use defaults where possible
  --no-prompt      Do not ask interactive prompts
  -h, --help       Show this help

All other options are forwarded to the private StuClaw Desktop installer.
EOF
}

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
  if [[ "$YES" -eq 1 ]]; then
    return 0
  fi
  if [[ "$NO_PROMPT" -eq 1 ]]; then
    return 1
  fi
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

gh_status_line() {
  if command_exists gh; then
    printf '%s\n' "  [OK] GitHub CLI  $(command -v gh) (installed; needed for private beta access)"
  else
    printf '%s\n' "  [!!] GitHub CLI  not installed"
  fi
}

forward_arg() {
  FORWARD_ARGS+=("$1")
  FORWARD_COUNT=$((FORWARD_COUNT + 1))
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
  printf '%s\n' "GitHub access"
  gh_status_line
  if command_exists gh; then
    return 0
  fi
  if [[ "$RUN_GH_INSTALL" -ne 1 ]]; then
    die "GitHub CLI is required to download private StuClaw Desktop."
  fi
  if prompt_yes_no "Install GitHub CLI now?"; then
    install_gh
  else
    die "Install GitHub CLI, then rerun."
  fi
  command_exists gh || die "GitHub CLI is still not available after install."
}

ensure_gh_auth() {
  if gh auth status --hostname "$HOSTNAME" >/dev/null 2>&1; then
    printf '%s\n' "  [OK] GitHub login $HOSTNAME (authenticated)"
    return 0
  fi
  printf '%s\n' "  [!!] GitHub login $HOSTNAME (required to download private StuClaw Desktop)"
  if [[ "$RUN_GH_AUTH" -ne 1 ]]; then
    die "GitHub login is required to download private StuClaw Desktop."
  fi
  if ! have_tty; then
    die "GitHub login requires an interactive terminal."
  fi
  log "Starting GitHub login."
  gh auth login --hostname "$HOSTNAME" --git-protocol https --scopes repo < /dev/tty > /dev/tty 2>&1
}

parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --no-gh-install)
        RUN_GH_INSTALL=0
        forward_arg "$1"
        shift
        ;;
      --no-gh-auth)
        RUN_GH_AUTH=0
        forward_arg "$1"
        shift
        ;;
      -y|--yes)
        YES=1
        forward_arg "$1"
        shift
        ;;
      --no-prompt)
        NO_PROMPT=1
        forward_arg "$1"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        forward_arg "$1"
        shift
        ;;
    esac
  done
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

cleanup() {
  if [[ -n "${INSTALLER_TMP:-}" ]]; then
    rm -f "$INSTALLER_TMP"
  fi
}

main() {
  INSTALLER_TMP="$(mktemp "${TMPDIR:-/tmp}/stuclaw-install.XXXXXX")"
  trap cleanup EXIT

  log "StuClaw Desktop bootstrap setup"
  ensure_gh
  ensure_gh_auth
  fetch_private_installer "$INSTALLER_TMP"
  if [[ "$FORWARD_COUNT" -gt 0 ]]; then
    STUCLAW_BOOTSTRAP_GH_READY=1 bash "$INSTALLER_TMP" "${FORWARD_ARGS[@]}"
  else
    STUCLAW_BOOTSTRAP_GH_READY=1 bash "$INSTALLER_TMP"
  fi
}

parse_args "$@"
main "$@"
