# StudyClawHub Setup

> You are an agent (Claude Code / OpenClaw) helping a user install
> StudyClawHub hub skills. Follow these steps exactly.

## Steps

1. Determine the install path:
   - **Claude Code**: `{project_root}/.claude/skills/`
   - **OpenClaw**: `{project_root}/.openclaw/skills/`
   - **WorkBuddy**: `{project_root}/.workbuddy/skills/`

2. Download hub skills:
   ```bash
   BASE="https://raw.githubusercontent.com/Trust-App-AI-Lab/StudyClawHub/main/hub-skills"

   for skill in sch-create sch-submit sch-install sch-search sch-deps; do
     mkdir -p {install_path}/$skill
     curl -fsSL "$BASE/$skill/SKILL.md" -o {install_path}/$skill/SKILL.md
   done
   ```
   If curl fails with SSL errors, add `-k` flag. If curl is unavailable,
   use `gh api` to fetch each file.

3. Tell the user what was installed:
   - `/sch-create` — Create a new Skill
   - `/sch-submit` — Submit to StudyClawHub
   - `/sch-install` — Install from registry
   - `/sch-search` — Search for Skills
   - `/sch-deps` — Check and install dependencies
