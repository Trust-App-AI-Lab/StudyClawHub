# StudyClawHub Setup

> You are an agent (Claude Code / OpenClaw) helping a user install
> StudyClawHub hub skills. Follow these steps exactly.

## Steps

1. Determine the install path based on your platform:
   - **Claude Code**: `{project_root}/.claude/skills/`
   - **OpenClaw / WorkBuddy**: `{project_root}/skills/`

   You know which platform you are — don't ask the user.

2. Download each hub skill:
   ```bash
   BASE="https://raw.githubusercontent.com/Trust-App-AI-Lab/StudyClawHub/main/hub-skills"

   for skill in sch-create sch-submit sch-install sch-search; do
     mkdir -p {install_path}/$skill
     curl -fsSL "$BASE/$skill/SKILL.md" -o {install_path}/$skill/SKILL.md
   done
   ```

3. Save the platform config:
   ```bash
   echo '{"platform":"claude-code"}' > {project_root}/.studyclawhub.json
   ```
   (Use `"openclaw"` if you're OpenClaw.)

4. Tell the user what was installed:
   - `/sch-create` — Create a new Skill
   - `/sch-submit` — Submit a Skill to StudyClawHub
   - `/sch-install` — Install a Skill from the registry
   - `/sch-search` — Search for Skills
