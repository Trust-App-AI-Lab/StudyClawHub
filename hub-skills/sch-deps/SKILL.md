---
name: sch-deps
description: "Check and install dependencies for a Skill or Agent. Use when a student says 'sch deps', 'check dependencies', 'install deps', 'missing tools', or 'what do I need to run this skill'."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - deps
  - dependencies
---

# StudyClawHub Deps

You are helping a student check and install dependencies for a Skill
or Agent.

## Workflow

### Step 1: Find SKILL.md / AGENTS.md

Look for SKILL.md or AGENTS.md files in the current project:

```bash
find . -name "SKILL.md" -o -name "AGENTS.md" | head -20
```

If none found, ask the student which skill they want to check.

### Step 2: Parse requirements

Read each file's YAML frontmatter. Extract from `metadata.openclaw`:

- `requires.env` — required environment variables
- `requires.bins` — required binaries (all must exist)
- `requires.anyBins` — at least one must exist
- `install` — auto-installable packages

### Step 3: Check environment variables

For each declared env var:

```bash
echo ${VAR_NAME:-__UNSET__}
```

Report which are set and which are missing.

### Step 4: Check binaries

For each declared binary:

```bash
which {bin} 2>/dev/null && echo "found" || echo "missing"
```

### Step 5: Install missing packages

If `metadata.openclaw.install` declares packages, offer to install:

| kind       | Command                     |
|------------|-----------------------------|
| `brew`     | `brew install {package}`    |
| `node`     | `npm install -g {package}`  |
| `uv`       | `uv tool install {package}` |
| `go`       | `go install {package}`      |

Ask before installing. Skip entries with non-matching `os` field.

### Step 6: Summary

Show a table:

```
Dependency check for: {skill-name}

Environment variables:
  API_KEY:     set
  SECRET:      MISSING — export SECRET="..."

Binaries:
  git:         found
  pdflatex:    MISSING

Packages:
  (none declared)

Status: 1 env var missing, 1 binary missing
```
