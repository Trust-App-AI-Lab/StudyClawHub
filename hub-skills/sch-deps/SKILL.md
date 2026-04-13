---
name: sch-deps
description: "Check, add, or fix dependencies for a Skill or Agent. Use when a student says 'sch deps', 'check dependencies', 'install deps', 'add deps', 'fix deps', 'generate dependencies', or 'what do I need to run this skill'."
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

The student may ask to **check** deps (default) or **add/fix** deps for an
existing Skill. Detect intent from phrases like "add deps", "fix deps",
"generate dependencies", "fill in requires". If unclear, ask.

---

## Mode A — Add / Fix Dependencies

Use this mode when the student wants to populate or update the
`metadata.openclaw` section of an existing SKILL.md.

### A1: Locate SKILL.md

```bash
find . -name "SKILL.md" | head -20
```

If multiple found, ask which one. Read the file.

### A2: Analyze the Skill

Read the **full prompt body** (below the YAML frontmatter) carefully.
Also scan nearby source files for clues:

```bash
# look for imports, shebang lines, tool invocations
find . -maxdepth 2 -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.sh" \) | head -20
```

From the prompt body and source files, infer:

| Signal | Maps to |
|--------|---------|
| `$ENV_VAR` or `${ENV_VAR}` in prompt/code | `requires.env` |
| CLI tool invoked (`git`, `gh`, `python3`, `node`, …) | `requires.bins` |
| "use X or Y" / fallback patterns | `requires.anyBins` |
| `pip install`, `npm install`, `brew install` in instructions | `install` entries |

### A3: Show proposed changes

Present a diff-style preview of the YAML frontmatter changes. Example:

```yaml
metadata:
  openclaw:
    requires:
      env:
        - OPENAI_API_KEY
      bins:
        - git
        - gh
      anyBins: []
    install:
      - kind: node
        package: tsx
```

Explain **why** each dependency was inferred (cite the line/phrase).

### A4: Apply changes

After the student confirms (or adjusts), edit the SKILL.md frontmatter
in place. Preserve the rest of the file exactly. If `metadata.openclaw`
already exists, merge — do not duplicate entries.

### A5: Verify round-trip

Re-read the file and confirm the YAML parses correctly:

```bash
head -50 SKILL.md
```

Then proceed to **Mode B** (check) automatically to validate everything.

---

## Mode B — Check & Install Dependencies

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
