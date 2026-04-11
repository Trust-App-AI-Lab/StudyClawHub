# StudyClawHub Skill Format

## Overview

A Skill is a folder in a GitHub repository. Students host Skills in their own repos
and register them with StudyClawHub.

## Required Structure

```
my-skill/
├── SKILL.md          ← Required. Frontmatter metadata + instructions.
└── (any other files)  ← Optional. References, scripts, examples, etc.
```

## SKILL.md

Markdown file with YAML frontmatter.

### Required Frontmatter

```yaml
---
name: my-skill-name
description: "One-line summary of what this Skill does."
author: github-username
version: 1.0.0
tags:
  - community-detection
  - graph-analysis
---
```

### Full Field Reference

| Field         | Type       | Required | Description                                    |
| ------------- | ---------- | -------- | ---------------------------------------------- |
| `name`        | `string`   | Yes      | Kebab-case identifier, URL-safe                |
| `description` | `string`   | Yes      | Short summary shown in search results          |
| `author`      | `string`   | Yes      | GitHub username of the author                  |
| `version`     | `string`   | Yes      | Semver version string                          |
| `tags`        | `string[]` | Yes      | Category tags for filtering/search             |
| `repo`        | `string`   | No       | GitHub repo URL (auto-filled by submit Skill)  |

### Body

After the frontmatter, write the Skill instructions in Markdown. This is what
Claude/OpenClaw will read when the Skill is activated.

## Example

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
---

# Network Analyzer

This Skill helps you analyze social network graphs...
```

## Slugs

- Derived from the `name` field.
- Must be lowercase and URL-safe: `^[a-z0-9][a-z0-9-]*$`.

## Allowed Files

Any text-based files: `.md`, `.js`, `.ts`, `.py`, `.json`, `.yaml`, `.txt`, `.csv`, `.svg`.
Binary files (images, zips) should not be included in the Skill folder itself.
