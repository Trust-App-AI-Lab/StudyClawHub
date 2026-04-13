---
name: sch-adapt
description: "Adapt an existing project into a Skill. Use when a student says 'sch adapt', 'adapt my skill', 'convert to skill', 'wrap as skill', '适配skill', or wants to turn existing code into a ClawHub-compatible Skill."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - adapt
  - convert
---

# StudyClawHub Adapt

You are helping a student turn an existing project into a
ClawHub-compatible Skill.

## Step 1: Understand the project

Scan the project directory. Read key files (README, main scripts,
config) to understand:

1. **What it does** — one sentence summary
2. **How it's triggered** — what user intents activate it
3. **Structure** — where main logic lives

Share your understanding and confirm with the student.

## Step 2: Determine Skill location

- If the whole repo IS the skill → SKILL.md at repo root
- If it's a subfolder → identify which folder

## Step 3: Generate SKILL.md

Draft the complete SKILL.md yourself — don't ask the student to fill
in fields one by one.

**Frontmatter:**

```yaml
---
name: {skill-name}
description: "{what it does — include trigger phrases}"
author: {github-username}
version: 1.0.0
tags:
  - {tag1}
  - {tag2}
---
```

Rules:
- `name`: kebab-case `^[a-z0-9][a-z0-9-]*$`
- `description`: one line, quoted, include trigger phrases
- `tags`: at least one

**Body:** Tailor the instructions to the student's actual project —
reference their real files, functions, and use cases:

1. One-line role statement
2. Step-by-step workflow using their actual code
3. Error handling

## Step 4: Validate

- [ ] `name` is kebab-case
- [ ] `description` present with trigger phrases
- [ ] `tags` has at least one
- [ ] `version` is valid semver
- [ ] Body references the actual project structure
- [ ] No binary files in the Skill folder

## Step 5: Next steps

Tell the student:
- `/sch-submit` to register on StudyClawHub
- `/sch-deps` to set up dependencies
