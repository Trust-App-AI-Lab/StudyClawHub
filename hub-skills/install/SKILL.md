---
name: studyclawhub-install
description: "Install a Skill from StudyClawHub. Use when a student says 'install skill X', 'download skill', 'get that skill', '安装skill', or '下载skill'. Fetches the Skill from the author's GitHub repo and installs it locally."
author: EnyanDai
version: 2.0.0
tags:
  - hub
  - install
  - download
---

# StudyClawHub Install

You are helping a student install a Skill from StudyClawHub.

## Config

`STUDYCLAWHUB_REPO` — the StudyClawHub repo (e.g. `instructor/StudyClawHub`).

## Workflow

### Step 1: Identify the Skill

The student provides a skill name or a search query. If the exact skill name
is given, look it up directly in `skills-index.json`. Otherwise, use the
search workflow first to help them find it.

Fetch the index:
```
https://raw.githubusercontent.com/{STUDYCLAWHUB_REPO}/main/skills-index.json
```

### Step 2: Fetch Skill details

From the index entry, get the `repo` URL and `path`. Show the student:
- Skill name, description, author
- Tags and version
- Star count (if available)
- Link to the GitHub repo

Ask the student to confirm installation.

### Step 3: Download the Skill

Clone or download the Skill from the author's GitHub repo:

```bash
# Option A: Sparse checkout (if skill is in a subdirectory)
git clone --depth 1 --filter=blob:none --sparse {repo_url} /tmp/skill-download
cd /tmp/skill-download
git sparse-checkout set {path}

# Option B: Full clone (if skill is the entire repo)
git clone --depth 1 {repo_url} /tmp/skill-download
```

### Step 4: Install locally

Copy the Skill folder to the student's local skills directory:

For Claude Code:
```bash
cp -r /tmp/skill-download/{path} ~/.claude/skills/{skill-name}/
```

For OpenClaw:
```bash
cp -r /tmp/skill-download/{path} ~/.openclaw/skills/{skill-name}/
```

### Step 5: Log the install and suggest starring

After successful installation, log it by creating a GitHub Issue:

```bash
gh issue create \
  --repo Trust-App-AI-Lab/StudyClawHub \
  --title "install: {skill-name}" \
  --label "install" \
  --body "Installed **{skill-name}** by @{skill-author}"
```

If `gh` CLI is not available, skip this step silently — install
counting is optional and should never block the actual installation.

Also suggest the student star the author's repo:

> If you like this Skill, consider starring the repo: {repo_url}

### Step 6: Confirm

Tell the student the Skill has been installed. They can now use it by
its trigger phrases (listed in the SKILL.md description).

Clean up temp files:
```bash
rm -rf /tmp/skill-download
```

## Notes

- Skills are installed from the author's own GitHub repo, not from
  StudyClawHub itself. StudyClawHub is just the registry.
- If the student wants to modify an installed Skill, they can edit it
  locally. To contribute changes back, they should fork the author's repo.
- Popularity is tracked in two ways: GitHub stars (fetched via API)
  and install count (tracked via GitHub Issues with "install" label).
- Install logging is best-effort. If it fails, the installation still
  succeeds.
