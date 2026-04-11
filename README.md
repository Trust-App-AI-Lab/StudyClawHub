# StudyClawHub

A lightweight Skill registry for the **Social Network Mining** course at
**HKUST-GZ, AI Thrust, TAI Lab** (PI: Enyan Dai).

Students write Claude Code / OpenClaw Skills, register them here, and
discover each other's work — all powered by GitHub, zero servers.

Inspired by [ClawHub](https://clawhub.ai), stripped down to the essentials.

## How it works

```
Student's GitHub repo          StudyClawHub (this repo)          GitHub Pages
┌──────────────┐    submit     ┌─────────────────┐    Actions    ┌──────────┐
│  my-skill/   │ ──────────▶  │  registry.json   │ ──────────▶  │  Static  │
│  SKILL.md    │  (Issue /    │                   │  build index  │  website  │
│              │   Skill)     │  skills-index.json│  + deploy     │          │
└──────────────┘              └─────────────────┘               └──────────┘
```

- **Students** host Skills in their own GitHub repos.
- **StudyClawHub** is just a registry — it stores repo URLs, not code.
- **GitHub Actions** fetches metadata from student repos, pulls star counts and install counts, and builds `skills-index.json`.
- **The website** renders the index as a browsable catalog sorted by stars, installs, time, or name.
- **Hub Skills** (`submit`, `search`, `install`) let students interact through Claude Code / OpenClaw.
- **Search** is LLM-driven: the search Skill reads all skills, semantically understands your query, ranks results, and injects the custom ordering into the website via `window.applyCustomOrder()`.

## Quick start for students

### 1. Write a Skill

Create a folder with a `SKILL.md` in your own GitHub repo:

```yaml
---
name: my-awesome-skill
description: "Does something cool with social networks."
author: your-github-username
version: 1.0.0
tags:
  - community-detection
  - graph
---

# My Awesome Skill

Instructions for Claude go here...
```

See [`docs/studyclawhub-skill-format.md`](docs/studyclawhub-skill-format.md) for the full spec, or copy the template from [`skills/_template/SKILL.md`](skills/_template/SKILL.md).

### 2. Push to your GitHub

```bash
git add my-skill/
git commit -m "Add my skill"
git push
```

### 3. Register it

**Option A — Website** (easiest):

Go to the [StudyClawHub website](https://trust-app-ai-lab.github.io/StudyClawHub/) → click **"+ Submit Skill"** → fill the Issue form (skill name, repo URL, path, username) → submit. A GitHub Action will process it automatically.

**Option B — submit Skill** (in Claude Code / OpenClaw):

> "Submit my skill to StudyClawHub"

The `studyclawhub-submit` Skill validates your folder and creates the registration Issue for you.

### 4. Done!

Your Skill will appear on the website within minutes. Other students can search, browse, and install it.

### 5. Browse, search, and install

- **Website**: browse all Skills sorted by stars, installs, or time.
- **Search**: in Claude Code, say `"search StudyClawHub for community detection"` — the LLM reads all Skills, ranks them semantically, and shows results on the website.
- **Install**: `"install network-analyzer from StudyClawHub"` — downloads the Skill to your local machine.
- **Star**: like a Skill? Star the author's GitHub repo — star counts show on the website.

## Built-in Skills

| Skill | What it does |
|-------|-------------|
| `studyclawhub-submit` | Validate your Skill folder and register it via GitHub Issue |
| `studyclawhub-search` | LLM-driven semantic search — ranks results and visualizes on the website |
| `studyclawhub-install` | Download a Skill from the author's repo + log the install |

## Popularity tracking

Skills have two popularity metrics, both visible on the website:

- **★ Stars** — GitHub star count on the author's repo, fetched automatically via API.
- **↓ Installs** — tracked via GitHub Issues: each install through the install Skill creates an Issue with the `install` label, counted by the build workflow.

## Repo layout

```
StudyClawHub/
├── .github/
│   ├── ISSUE_TEMPLATE/register-skill.yml  ← Skill registration form
│   └── workflows/
│       ├── auto-merge-registry.yml        ← Process registration Issues
│       └── build-index.yml                ← Build index + deploy Pages
├── docs/studyclawhub-skill-format.md      ← Skill format spec
├── hub-skills/
│   ├── submit/SKILL.md                    ← Register your Skill
│   ├── search/SKILL.md                    ← LLM-driven search
│   └── install/SKILL.md                   ← Install a Skill locally
├── site/index.html                        ← Static website
├── skills/_template/SKILL.md              ← Starter template
├── registry.json                          ← Skill registry (repo URLs)
├── skills-index.json                      ← Auto-generated metadata index
└── CLAUDE.md                              ← Project rules for Claude
```

## Architecture comparison

| Concern | ClawHub | StudyClawHub |
|---------|---------|-------------|
| Data store | Convex cloud DB | `registry.json` in GitHub |
| Skill hosting | Convex file storage | Student's own GitHub repo |
| Search | OpenAI embeddings | LLM-driven (Claude reads all skills) |
| Auth | GitHub OAuth via Convex | GitHub account (open an Issue) |
| Popularity | Convex DB | GitHub stars + Issue-based install count |
| Website | TanStack Start SPA | Single static HTML file |
| Interaction | CLI (`clawhub publish`) | Hub Skills + website |
| Cost | Convex free tier | $0 — pure GitHub |

## For instructors

1. Fork/clone this repo to your organization.
2. Enable GitHub Pages (Settings → Pages → Source: **GitHub Actions**).
3. Share the website URL and hub-skills with students.
4. Students register Skills via Issue form or the submit Skill.
5. GitHub Actions processes registrations, builds the index, deploys the site.
6. No collaborator access needed — students only need a GitHub account to open Issues.

## License

[MIT](LICENSE)
