# StudyClawHub Skill Format

> **ClawHub-compatible** — Skills created for StudyClawHub can be submitted to
> [ClawHub](https://clawhub.ai) without modification.

## Overview

A Skill is a folder in a GitHub repository. Students host Skills in their own
repos and register them with StudyClawHub.

## Required Structure

```
my-skill/
├── SKILL.md          ← Required. Frontmatter metadata + instructions.
└── (any other files)  ← Optional. Scripts, examples, references, etc.
```

## SKILL.md

Markdown file with YAML frontmatter at the top, followed by instructions for
Claude / OpenClaw.

### Frontmatter Fields

#### Required

| Field         | Type       | Description                                    |
| ------------- | ---------- | ---------------------------------------------- |
| `name`        | `string`   | Kebab-case identifier, URL-safe (`^[a-z0-9][a-z0-9-]*$`) |
| `description` | `string`   | Short summary shown in search results          |

#### Recommended (StudyClawHub)

| Field         | Type       | Description                                    |
| ------------- | ---------- | ---------------------------------------------- |
| `author`      | `string`   | GitHub username of the author                  |
| `version`     | `string`   | Semver version string (e.g. `1.0.0`)           |
| `tags`        | `string[]` | Category tags for filtering/search             |

#### Optional (ClawHub metadata)

Declare runtime requirements under `metadata.openclaw` so that ClawHub's
security scanner can verify your skill. These fields are optional for
StudyClawHub but recommended if you plan to publish to ClawHub.

| Field                            | Type       | Description                                         |
| -------------------------------- | ---------- | --------------------------------------------------- |
| `metadata.openclaw.requires.env` | `string[]` | Environment variables your skill expects             |
| `metadata.openclaw.requires.bins`| `string[]` | CLI binaries that must all be installed               |
| `metadata.openclaw.requires.anyBins` | `string[]` | CLI binaries where at least one must exist       |
| `metadata.openclaw.requires.config`  | `string[]` | Config file paths your skill reads               |
| `metadata.openclaw.primaryEnv`   | `string`   | The main credential env var for your skill           |
| `metadata.openclaw.install`      | `object[]` | Dependency install specs (brew, node, go, uv)        |

### Minimal Example (StudyClawHub only)

```yaml
---
name: network-analyzer
description: "Analyze social network structure and detect communities."
author: zhangsan
version: 1.0.0
tags:
  - community-detection
  - graph-analysis
---

# Network Analyzer

This Skill helps you analyze social network graphs...
```

### Full Example (ClawHub-compatible)

```yaml
---
name: network-analyzer
description: "Analyze social network structure and detect communities."
author: zhangsan
version: 1.0.0
tags:
  - community-detection
  - graph-analysis
  - social-network
metadata:
  openclaw:
    requires:
      env:
        - OPENAI_API_KEY
      bins:
        - python3
        - pip
    primaryEnv: OPENAI_API_KEY
    install:
      - kind: uv
        package: networkx
      - kind: uv
        package: matplotlib
---

# Network Analyzer

This Skill helps you analyze social network graphs...
```

## Body

After the frontmatter, write the Skill instructions in Markdown. This is what
Claude / OpenClaw reads when the Skill is activated. Include:

- What the Skill does and when to trigger it
- Step-by-step workflow
- Example commands or interactions
- Error handling guidance

## Naming

- Derived from the `name` field.
- Must be lowercase and URL-safe: `^[a-z0-9][a-z0-9-]*$`.

## Allowed Files

Any text-based files: `.md`, `.js`, `.ts`, `.py`, `.json`, `.yaml`, `.txt`,
`.csv`, `.svg`. Binary files (images, zips) should not be included in the
Skill folder itself.

## Publishing

- **StudyClawHub**: Use the `submit` Skill or the website Submit form to
  register via GitHub Issue.
- **ClawHub**: Run `/clawhub publish` in your Skill folder. Ensure
  `metadata.openclaw` is declared so the security scanner passes.
