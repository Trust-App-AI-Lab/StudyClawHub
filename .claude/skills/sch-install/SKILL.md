---
name: sch-install
description: "Install a Skill or Agent from StudyClawHub. Use when a student says 'sch install X', 'install from StudyClawHub', 'get skill from sch', or 'download from StudyClawHub'. Clones the repo and installs it locally."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - install
  - download
metadata:
  openclaw:
    requires:
      bins:
        - git
      anyBins:
        - gh
---

# StudyClawHub Install

You are helping a student install a Skill or Agent from StudyClawHub.

## Config

StudyClawHub repo: `Trust-App-AI-Lab/StudyClawHub`

## Workflow

### Step 1: Identify the Skill / Agent

The student provides a skill name or a search query. If the exact name
is given, look it up directly in `skills-index.json`. Otherwise, use the
search workflow first to help them find it.

Fetch the index:
```
https://trust-app-ai-lab.github.io/StudyClawHub/skills-index.json
```

If the skill is **not found** in the StudyClawHub index, tell the student:

> This skill isn't registered on StudyClawHub. If it's a community skill,
> you can try installing it from ClawHub instead:
> ```
> /install {skill-name}
> ```

Then stop — do not continue with the StudyClawHub install flow.

### Step 2: Show details and confirm

From the index entry, get the `repo` URL. Show the student:
- Skill name, description, author
- Tags and version
- Star count (if available)
- Link to the GitHub repo

Ask the student to confirm installation.

### Step 3: Download

Download from the `repo` URL. How to download depends on `path` and
`type` from the index entry:

**Skill = entire repo** (`path` is `.` or empty, or `type` is `agent`):

```bash
git clone --depth 1 {repo_url} {skill-name}
```

**Skill = subdirectory** (`path` is e.g. `skills/my-skill`):

```bash
tmpdir=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse {repo_url} "$tmpdir"
cd "$tmpdir" && git sparse-checkout set {path}
cp -r {path} {target_dir}/{skill-name}
rm -rf "$tmpdir"
```

### Step 4: Confirm

Tell the student the Skill has been installed. Show a summary:

- Skill name and version
- Install location
- Trigger phrases from the SKILL.md description

Suggest running `/sch-deps` to check and install dependencies.

## Notes

- Skills are installed from the author's own GitHub repo, not from
  StudyClawHub itself. StudyClawHub is just the registry.
- The entire repo is cloned as-is — never rearrange files, because
  skills may depend on the repo's directory structure.
- If the student wants to modify an installed Skill, they can edit it
  locally. To contribute changes back, they should fork the author's repo.
- Popularity is tracked via GitHub stars (fetched via API).
- Dependency installation follows ClawHub conventions: same `kind` types,
  same priority order, same platform filtering.
