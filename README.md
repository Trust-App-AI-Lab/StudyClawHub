# StudyClawHub

A lightweight Skill registry for university courses.
Built at **HKUST-GZ, AI Thrust, TAI Lab** (PI: Enyan Dai).

Students write Skills, register them here, and discover each other's
work — all powered by GitHub, zero servers.

Inspired by [ClawHub](https://clawhub.ai), stripped down to the essentials.
Skill format is **ClawHub-compatible** — publish to both without modification.

## Setup (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/Trust-App-AI-Lab/StudyClawHub/main/setup.sh | bash
```

Choose your platform (Claude Code / OpenClaw / WorkBuddy) and the script
installs four hub skills into your current directory:

| Command | What it does |
|---------|-------------|
| `/sch-create` | Create a new Skill from scratch (generates SKILL.md, creates GitHub repo, pushes) |
| `/sch-submit` | Submit a Skill to StudyClawHub (validates and registers via GitHub Issue) |
| `/sch-install` | Install a Skill from StudyClawHub |
| `/sch-search` | LLM-driven semantic search across all registered Skills |

## Quick start

### 1. Setup

Run the setup command above in your project directory. Pick your platform
when prompted.

### 2. Create a Skill

Type `/sch-create`. The agent guides you through everything: what your
Skill does, generates the `SKILL.md`, creates a GitHub repo, and pushes it.

### 3. Submit it

Type `/sch-submit`. Or go to the [website](https://trust-app-ai-lab.github.io/StudyClawHub/)
→ click **"+ Submit Skill"** → fill the form → submit.

### 4. Discover Skills

- **Search**: `/sch-search` — the LLM reads all Skills, ranks them semantically, and shows results on the website.
- **Install**: `/sch-install` — downloads a Skill to your local machine.
- **Browse**: visit the [website](https://trust-app-ai-lab.github.io/StudyClawHub/) — sort by stars, installs, time, or name.
- **Star**: like a Skill? Star the author's GitHub repo — counts show on the website.

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
- **GitHub Actions** fetches metadata, star counts, and install counts, then builds `skills-index.json`.
- **The website** renders the index as a browsable catalog.
- **Hub Skills** (`/sch-create`, `/sch-submit`, `/sch-search`, `/sch-install`) are the CLI interaction layer.
- **Search** is LLM-driven: Claude reads all skills, ranks them semantically, and injects results into the website via `window.applyCustomOrder()`.

## Skill format

Skills use `SKILL.md` with YAML frontmatter — same format as ClawHub:

```yaml
---
name: my-awesome-skill
description: "Does something cool."
author: your-github-username
version: 1.0.0
tags:
  - analysis
  - graph
metadata:          # optional — needed for ClawHub publish
  openclaw:
    requires:
      env:
        - SOME_API_KEY
      bins:
        - python3
    primaryEnv: SOME_API_KEY
---

# My Awesome Skill

Instructions for the agent go here...
```

See [`docs/studyclawhub-skill-format.md`](docs/studyclawhub-skill-format.md) for the full spec.

## Popularity tracking

- **★ Stars** — GitHub star count on the author's repo, fetched via API.
- **↓ Installs** — tracked via GitHub Issues with the `install` label.

## Repo layout

```
StudyClawHub/
├── setup.sh                                ← One-line student setup
├── hub-skills/
│   ├── sch-create/SKILL.md                 ← /sch-create
│   ├── sch-submit/SKILL.md                 ← /sch-submit
│   ├── sch-search/SKILL.md                 ← /sch-search
│   └── sch-install/SKILL.md                ← /sch-install
├── site/index.html                         ← Static website
├── docs/studyclawhub-skill-format.md       ← Skill format spec
├── registry.json                           ← Skill registry
├── skills-index.json                       ← Auto-generated index
├── .github/workflows/                      ← CI/CD
└── CLAUDE.md                               ← Project rules
```

## For instructors

1. Fork this repo to your organization.
2. Enable GitHub Pages (Settings → Pages → Source: **GitHub Actions**).
3. Share the setup command with students.
4. Students create, submit, and discover Skills through the hub commands.
5. No collaborator access needed — students only need a GitHub account.

## License

[MIT](LICENSE)
