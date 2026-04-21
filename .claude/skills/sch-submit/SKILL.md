---
name: sch-submit
description: "Submit your Skill(s) to StudyClawHub. Use when a student says 'sch submit', 'submit to StudyClawHub', 'register on StudyClawHub', 'publish to sch', or 'sch publish'. Scans the repo for all SKILL.md files and registers them via GitHub Issues."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - submit
  - publish
metadata:
  openclaw:
    requires:
      bins:
        - git
      anyBins:
        - gh
---

# StudyClawHub Submit

You are helping a student submit their Skill(s) to the StudyClawHub registry.
No write access or fork is needed — registration is done via GitHub Issues.

## Config

StudyClawHub repo: `Trust-App-AI-Lab/StudyClawHub`

## Workflow

### Step 1: Scan for SKILL.md files

Search the student's project for all SKILL.md files:

```bash
find . -name "SKILL.md" -type f
```

Show the student what was found, e.g.:

> Found 3 skills in your project:
> 1. `./SKILL.md` — network-analyzer
> 2. `./skills/visualize/SKILL.md` — network-visualizer
> 3. `./skills/export/SKILL.md` — graph-exporter

If no SKILL.md is found, tell the student to run `/sch-create` first.

**If multiple SKILL.md files are found**, ask the student:

> Is this an **Agent** (these skills work together as one project), or
> are they **independent skills** that happen to be in the same repo?

- **Agent** — register an agent entry for the whole repo, plus each
  selected child skill with `agent` field pointing to the agent name.
  Ask the student for an overall agent name and description.
  Then check if `AGENTS.md` exists at the repo root. If not, auto-create
  one with YAML frontmatter (same format as SKILL.md: name, description,
  author, version, tags), commit and push it. The build-index workflow
  reads `AGENTS.md` for agent metadata.
- **Independent** — register each selected skill separately, no
  agent association.

**If only one SKILL.md is found:**

- If it's at the repo root (`./SKILL.md`), register as a standalone skill.
- If it's in a subdirectory (e.g. `./skills/foo/SKILL.md`), ask:
  > This skill is not at the repo root. Is it:
  > 1. A **child skill** of an Agent (the repo has or should have an `AGENTS.md` at root)?
  > 2. An **independent skill** that just happens to be in a subdirectory?
  - If **child skill** — check for `AGENTS.md` at root. If it exists, read
    the agent name from it. If not, help the student create one (same flow
    as the multi-skill Agent path above). Register the agent first, then
    the skill with `agent` field set.
  - If **independent** — register as a standalone skill.

### Step 2: Validate each Skill / Agent

For agents, validate `AGENTS.md` at the repo root. For skills, validate
each `SKILL.md`. The frontmatter format is the same for both:

- [ ] YAML frontmatter has required fields: `name`, `description`
- [ ] Recommended fields present: `author`, `version`, `tags`
- [ ] `name` is kebab-case: `^[a-z0-9][a-z0-9-]*$`
- [ ] `author` matches their GitHub username
- [ ] `tags` has at least one tag
- [ ] `version` is valid semver

If validation fails, help the student fix the issues before proceeding.

### Step 3: Push to GitHub

Check if the student's project is in a Git repo with a remote:

```bash
git remote -v
```

**Case A — Already in a repo with a remote:**

Ensure changes are committed and pushed:

```bash
git add .
git commit -m "Update skills"
git push
```

**Case B — Not in a repo yet:**

```bash
git init
git add .
git commit -m "Initial commit"
```

Then check if `gh` is available:

```bash
gh --version
```

**If `gh` is available:**

```bash
gh repo create {repo-name} --public --source=. --push
```

**If `gh` is NOT available**, tell the student to create a repo manually:
- Open `https://github.com/new` in their browser
- Must be **Public**, do NOT initialize with README
- After creation, run:

```bash
git remote add origin https://github.com/{username}/{repo}.git
git branch -M main
git push -u origin main
```

Record the full repo URL.

### Step 4: Register via GitHub Issues

For **each** selected skill, build a pre-filled Issue URL:

```
https://github.com/Trust-App-AI-Lab/StudyClawHub/issues/new?title={encoded_title}&body={encoded_body}
```

Where:
- `title` = `register: {skill-name}`
- `body` = the following (URL-encoded):
```
### Skill name

{skill-name}

### Description

{description from SKILL.md/AGENTS.md frontmatter}

### Version

{version from frontmatter}

### Tags

{comma-separated tags from frontmatter}

### GitHub repo URL

{repo-url}

### Path to Skill folder

{path-relative-to-repo-root}

### Type

{skill or agent}

### Agent name

{agent-name, only if this is a child skill of an agent}

### Your GitHub username

{author}
```

For agent registration, first create the agent issue (type = agent),
then create issues for each child skill (type = skill, with agent
name filled in).

**IMPORTANT: Submit issues one at a time.** Wait for each issue to be
closed by the GitHub Action before creating the next one. This avoids
concurrent push conflicts in the registry. Use this loop:

1. Create the issue
2. Wait ~15 seconds, then check if it was closed:
   ```bash
   gh issue view {number} --repo Trust-App-AI-Lab/StudyClawHub --json state --jq .state
   ```
3. If CLOSED, proceed to the next. If still OPEN after 60 seconds,
   check the Action run for errors.

If there's only one skill, give the student the link to open.

If `gh` is available, create each issue sequentially:

```bash
gh issue create \
  --repo Trust-App-AI-Lab/StudyClawHub \
  --title "register: {skill-name}" \
  --body "{body}"
```

If `gh` is not available and there are multiple skills, give the
student all the links and tell them to open them **one at a time**,
waiting for each to be closed before opening the next.

### Step 5: Confirm

Tell the student:
- A GitHub Action will automatically add their Skill(s) to the registry
  and close the Issue(s).
- Their Skill(s) will appear on the StudyClawHub website within minutes.
- No extra tools or permissions needed — just a GitHub account.

## Error Handling

- If the student's repo is private, registration still works — metadata
  from the Issue body is stored in registry.json as a fallback. The
  skill will appear on the website but with limited info until the
  repo is made public.
- If a skill with the same name exists, the Action will update the
  existing entry instead of creating a duplicate.

## Notes

- Students own their Skill code in their own GitHub repo.
- StudyClawHub only stores a reference (repo URL + path).
- The entire registration flow requires zero permissions on the
  StudyClawHub repo — just a GitHub account to open an Issue.
