# StudyClawHub Skill Format

> **ClawHub-compatible** — Skills created for StudyClawHub can be submitted to
> [ClawHub](https://clawhub.ai) without modification.

## TL;DR

A Skill is just a folder with a `SKILL.md` file. You don't need to memorize
the format — just tell Claude Code or OpenClaw:

```
Help me create a skill for StudyClawHub
```

It will handle the rest. If you run into any issues, just describe the problem
to Claude / OpenClaw and they'll figure it out.

## Minimal Example

```yaml
---
name: my-cool-skill
description: "What this skill does in one sentence."
author: your-github-username
version: 1.0.0
tags:
  - topic1
  - topic2
---

# My Cool Skill

Instructions for Claude / OpenClaw go here...
```

That's it. Push to GitHub, then submit to StudyClawHub.

## Field Reference

| Field         | Required | Description                                    |
| ------------- | -------- | ---------------------------------------------- |
| `name`        | Yes      | Lowercase kebab-case (`my-cool-skill`)         |
| `description` | Yes      | One-line summary for search results            |
| `author`      | Recommended | Your GitHub username                        |
| `version`     | Recommended | Semver (`1.0.0`)                            |
| `tags`        | Recommended | Category tags for filtering                 |

For ClawHub compatibility, you can also add `metadata.openclaw` fields
(env vars, binary requirements, etc.) — ask Claude about it if needed.
