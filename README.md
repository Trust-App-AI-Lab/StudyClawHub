# StudyClawHub

A lightweight Skill registry for university courses.
Built at **HKUST-GZ, AI Thrust, TAI Lab** (PI: Enyan Dai).

Students write Skills, register them here, and discover each other's
work — all powered by GitHub, zero servers.

Inspired by [ClawHub](https://clawhub.ai), stripped down to the essentials.
Skill format is **ClawHub-compatible** — publish to both without modification.

## Setup

Tell Claude Code or OpenClaw:

> 按照 https://raw.githubusercontent.com/Trust-App-AI-Lab/StudyClawHub/main/SETUP.md 安装

After setup you get four commands:

| Command | What it does |
|---------|-------------|
| `/sch-create` | Create a new Skill (generates SKILL.md, creates GitHub repo, pushes) |
| `/sch-submit` | Submit a Skill to StudyClawHub (registers via GitHub Issue) |
| `/sch-install` | Install a Skill from StudyClawHub |
| `/sch-search` | LLM-driven semantic search across all registered Skills |

## Quick start

### 1. Create a Skill

> Help me create a skill for StudyClawHub

### 2. Submit it

> Submit my skill to StudyClawHub

Or go to the [website](https://trust-app-ai-lab.github.io/StudyClawHub/)
→ click **"+ Submit Skill"** → fill the form → submit.

### 3. Discover Skills

> Search StudyClawHub for a skill about community detection

Or [browse the website](https://trust-app-ai-lab.github.io/StudyClawHub/) — sort by stars, installs, time, or name.

## How it works

```
Student's GitHub repo          StudyClawHub (this repo)          GitHub Pages
┌──────────────┐    submit     ┌─────────────────┐    Actions    ┌──────────┐
│  my-skill/   │ ──────────▶  │  registry.json   │ ──────────▶  │  Static  │
│  SKILL.md    │  (Issue)     │                   │  build index  │  website  │
│              │              │  skills-index.json│  + deploy     │          │
└──────────────┘              └─────────────────┘               └──────────┘
```

- **Students** host Skills in their own GitHub repos.
- **StudyClawHub** is just a registry — it stores repo URLs, not code.
- **GitHub Actions** fetches metadata, star counts, and install counts, then deploys the website.
- **Hub Skills** are the CLI interaction layer — the agent does everything.

## Skill format

A Skill is just a folder with a `SKILL.md`:

```yaml
---
name: my-awesome-skill
description: "Does something cool."
author: your-github-username
version: 1.0.0
tags:
  - analysis
  - graph
---

# My Awesome Skill

Instructions for the agent go here...
```

Don't worry about the format — just tell the agent to create a skill and
it will handle everything. See [`docs/`](docs/studyclawhub-skill-format.md)
if you want the full spec.

## For instructors

1. Fork this repo to your organization.
2. Enable GitHub Pages (Settings → Pages → Source: **GitHub Actions**).
3. Share this README with students.
4. Students create, submit, and discover Skills through the agent.
5. No collaborator access needed — students only need a GitHub account.

## License

[MIT](LICENSE)
