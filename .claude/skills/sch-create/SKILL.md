---
name: sch-create
description: "Create a new Skill from scratch. Use when a student says 'sch create', 'create a skill', 'new skill', '创建skill', or wants to start a fresh Skill project."
author: EnyanDai
version: 0.2.0
tags:
  - hub
  - create
  - scaffold
---

# StudyClawHub Create

You are helping a student create a new Skill from scratch.

## Step 1: Understand what to build

Ask the student:

1. **What does your Skill do?**
2. **What should it be called?** — Suggest a kebab-case name if unsure.

## Step 2: Choose location

Create the Skill folder:

```
{skill-name}/
├── SKILL.md
└── (supporting files if needed)
```

## Step 3: Generate SKILL.md

Draft the complete SKILL.md yourself based on the student's answers.

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

**Body:** Write clear Markdown instructions for the agent:

1. One-line role statement
2. Step-by-step workflow
3. Error handling

## Step 4: Validate

- [ ] `name` is kebab-case
- [ ] `description` present with trigger phrases
- [ ] `tags` has at least one
- [ ] `version` is valid semver
- [ ] Body has clear instructions

## Step 5: Next steps

Tell the student:
- `/sch-submit` to register on StudyClawHub
- `/sch-deps` to set up dependencies
