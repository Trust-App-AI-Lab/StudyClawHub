#!/usr/bin/env bash
# StudyClawHub — One-line setup for students
# Usage: curl -fsSL https://raw.githubusercontent.com/Trust-App-AI-Lab/StudyClawHub/main/setup.sh | bash
#
# Installs hub skills for your chosen platform.
# Commands: /sch-create, /sch-submit, /sch-install, /sch-search

set -euo pipefail

REPO="https://github.com/Trust-App-AI-Lab/StudyClawHub.git"
TMP_DIR="$(mktemp -d)"

echo "==> StudyClawHub setup"
echo ""
echo "    Which platform are you using?"
echo "    1) Claude Code"
echo "    2) OpenClaw / WorkBuddy"
echo "    3) Both"
echo ""
read -rp "    Enter 1, 2, or 3: " choice

TARGETS=()
case $choice in
  1) TARGETS=(".claude/skills") ;;
  2) TARGETS=("skills") ;;
  3) TARGETS=(".claude/skills" "skills") ;;
  *)
    echo "    Invalid choice. Exiting."
    exit 1
    ;;
esac

echo ""
echo "    Downloading hub skills ..."

# Clone only hub-skills
git clone --depth 1 --filter=blob:none --sparse "$REPO" "$TMP_DIR" 2>/dev/null
cd "$TMP_DIR"
git sparse-checkout set hub-skills 2>/dev/null
cd - > /dev/null

# Install to chosen directories
for SKILLS_DIR in "${TARGETS[@]}"; do
  mkdir -p "$SKILLS_DIR"

  for skill in sch-create sch-submit sch-install sch-search; do
    folder="$TMP_DIR/hub-skills/$skill"
    if [ -d "$folder" ]; then
      rm -rf "$SKILLS_DIR/$skill"
      cp -r "$folder" "$SKILLS_DIR/$skill"
    fi
  done
done

# Clean up
rm -rf "$TMP_DIR"

echo ""
echo "    ✓ /sch-create   — Create a new Skill"
echo "    ✓ /sch-submit   — Submit a Skill to StudyClawHub"
echo "    ✓ /sch-install  — Install a Skill from StudyClawHub"
echo "    ✓ /sch-search   — Search for Skills on StudyClawHub"
echo ""
echo "==> Done! Type /sch-create to get started."
