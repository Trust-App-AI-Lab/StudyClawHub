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
git clone --depth 1 --filter=blob:none --sparse {repo_url} /tmp/sch-dl
cd /tmp/sch-dl && git sparse-checkout set {path}
cp -r {path} {target_dir}/{skill-name}
rm -rf /tmp/sch-dl
```

### Step 4: Install dependencies

After cloning, read the SKILL.md(s) in the repo and parse
`metadata.openclaw` from the YAML frontmatter.

#### 4a: Check `requires.env`

If the skill declares `requires.env`, check each environment variable:

```bash
echo $ENV_VAR_NAME
```

For any that are **not set**, warn the student:

> This skill requires the environment variable `{VAR_NAME}` but it is
> not set. You can set it with:
> ```bash
> export {VAR_NAME}="your-value-here"
> ```

If a `primaryEnv` is declared, highlight it as the most important one.

Do **not** block the installation — just warn.

#### 4b: Check `requires.bins`

If the skill declares `requires.bins`, check each binary:

```bash
which {binary_name}
```

For any that are **missing**, warn the student.

#### 4c: Auto-install packages from `metadata.openclaw.install`

If the skill declares `metadata.openclaw.install`, ask the student:

> This skill has dependencies to install. Install them now? (Y/n)

If yes, process each entry. Each entry has a `kind` and a `package`.
Run the corresponding command:

| kind       | Command                          | Notes                                    |
|------------|----------------------------------|------------------------------------------|
| `brew`     | `brew install {package}`         | macOS / Linuxbrew                        |
| `node`     | `npm install -g {package}`       | Or pnpm/yarn if student prefers          |
| `go`       | `go install {package}`           | Requires Go on PATH                      |
| `uv`       | `uv tool install {package}`      | Installs to `~/.local/bin`               |
| `download` | Fetch URL and extract            | Check `url`, `type` fields in the entry  |

**Installer priority:** If multiple entries provide the same binary,
prefer: `brew` > `uv` > `node` > `go` > `download`. Only run one
installer per binary.

**Platform filtering:** If an entry has an `os` field (e.g.
`os: ["darwin"]`), skip it on non-matching platforms.

**Error handling:** If an installer fails, warn but continue. Never
block the overall installation.

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

Tell the student the Skill has been installed. Show a summary:

- Skill name and version
- Install location
- Dependencies installed (if any)
- Warnings (missing env vars, failed dependency installs, etc.)
- Trigger phrases from the SKILL.md description

## Notes

- Skills are installed from the author's own GitHub repo, not from
  StudyClawHub itself. StudyClawHub is just the registry.
- The entire repo is cloned as-is — never rearrange files, because
  skills may depend on the repo's directory structure.
- If the student wants to modify an installed Skill, they can edit it
  locally. To contribute changes back, they should fork the author's repo.
- Popularity is tracked in two ways: GitHub stars (fetched via API)
  and install count (tracked via GitHub Issues with "install" label).
- Install logging is best-effort. If it fails, the installation still
  succeeds.
- Dependency installation follows ClawHub conventions: same `kind` types,
  same priority order, same platform filtering.
