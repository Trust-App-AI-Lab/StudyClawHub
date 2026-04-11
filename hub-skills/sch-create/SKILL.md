---
name: sch-create
description: "Scaffold a new Skill for StudyClawHub. Use when a student says 'sch create', 'sch new', 'create a StudyClawHub skill', 'new skill for StudyClawHub', or 'scaffold a skill for sch'. Generates a complete Skill folder with SKILL.md, creates a GitHub repo, and pushes it."
author: EnyanDai
version: 1.0.0
tags:
  - hub
  - create
  - scaffold
metadata:
  openclaw:
    requires:
      bins:
        - git
      anyBins:
        - gh
---

# StudyClawHub Create

You are helping a student create a new Skill from scratch. The generated Skill
will be registered on StudyClawHub. The format is also compatible with
ClawHub, so students can publish there too if they want.

## Workflow

### Step 1: Understand what the student wants to build

Ask the student:

1. **What does your Skill do?** — Get a clear description of the functionality.
2. **What should it be called?** — Suggest a kebab-case name based on their
   description if they're unsure (e.g. `network-analyzer`, `sentiment-checker`).
3. **Does it need any external tools or APIs?** — Find out if the Skill
   requires environment variables (API keys), CLI tools (python3, curl, etc.),
   or package dependencies (pip, npm).

### Step 2: Choose a location

Ask the student where to create the Skill folder:

- If they already have a project repo, create the folder inside it.
- If not, create a new folder that they can later push to GitHub.

The folder structure will be:

```
{skill-name}/
├── SKILL.md
└── (any supporting files the student needs)
```

### Step 3: Generate SKILL.md

Create the `SKILL.md` file with the following structure:

```yaml
---
name: {skill-name}
description: "{one-line description}"
author: {github-username}
version: 1.0.0
tags:
  - {tag1}
  - {tag2}
metadata:
  openclaw:
    requires:
      env:
        - {ENV_VAR if needed}
      bins:
        - {binary if needed}
    primaryEnv: {main env var if needed}
---
```

**Rules for frontmatter:**

- `name`: Must be kebab-case, URL-safe: `^[a-z0-9][a-z0-9-]*$`
- `description`: One line, quoted, explain what it does and when to trigger it.
  Include common trigger phrases in both English and Chinese if the student
  is from a Chinese-language course.
- `author`: Student's GitHub username
- `version`: Start at `1.0.0`
- `tags`: At least one tag, lowercase, related to the skill's domain
- `metadata.openclaw`: Only include if the skill actually needs env vars,
  binaries, or dependencies. Omit entirely for pure-prompt skills.

**Rules for the body (instructions):**

After the frontmatter, write a clear Markdown document that tells Claude /
the agent exactly how to execute the Skill. The body should include:

1. **One-line role statement** — "You are helping the user do X."
2. **When to trigger** — Describe the user intents that activate this Skill.
3. **Step-by-step workflow** — Numbered steps with clear actions.
4. **Input/output format** — What the Skill expects and produces.
5. **Error handling** — Common failure modes and how to recover.
6. **Examples** (optional) — Sample interactions showing expected behavior.

Write the body collaboratively with the student — don't just generate a
generic template. Ask about their specific use case and tailor the
instructions accordingly.

### Step 4: Create supporting files (if needed)

If the Skill needs helper scripts, example data, or reference files,
create them in the same folder. Common patterns:

- `examples/` — Sample input/output files
- `templates/` — Template files the Skill uses
- `lib/` — Helper scripts (`.py`, `.js`, `.sh`)

### Step 5: Validate

Before finishing, validate the generated Skill:

- [ ] `SKILL.md` exists with valid YAML frontmatter
- [ ] `name` is kebab-case and URL-safe
- [ ] `description` is present and meaningful
- [ ] `author` matches student's GitHub username
- [ ] `version` is valid semver
- [ ] `tags` has at least one tag
- [ ] If `metadata.openclaw.requires.env` is declared, those env vars are
      actually referenced in the instructions
- [ ] If `metadata.openclaw.requires.bins` is declared, those binaries are
      actually used in the instructions
- [ ] Body has clear step-by-step instructions
- [ ] No binary files in the Skill folder

### Step 6: Create GitHub repo and push

Help the student create a GitHub repo and push their Skill. First check
the current state:

```bash
cd {skill-folder-parent}
git remote -v
```

**Case A — Already in a git repo with a remote:**

```bash
git add {skill-folder}/
git commit -m "Add {skill-name} skill"
git push
```

Skip to Step 7.

**Case B — Not in a git repo yet:**

First initialize git and commit:

```bash
cd {skill-folder-parent}
git init
git add .
git commit -m "Initial commit: {skill-name} skill"
```

Then check if GitHub CLI is available:

```bash
gh --version
```

**If `gh` is available**, create the repo directly:

```bash
gh repo create {skill-name} --public --source=. --push
```

This creates the GitHub repo, sets the remote, and pushes — all in one
command. The repo will be at `https://github.com/{username}/{skill-name}`.

If `gh auth status` shows not logged in, run `gh auth login` first and
follow the browser-based OAuth flow.

**If `gh` is NOT available**, fall back to manual creation:

1. Tell the student to open `https://github.com/new` in their browser
2. Repo name: suggest using the skill name (e.g. `{skill-name}`)
3. Must be **Public**
4. Do NOT initialize with README

After the student creates the repo and gives the URL:

```bash
git remote add origin https://github.com/{username}/{repo}.git
git branch -M main
git push -u origin main
```

**Verify** the push succeeded:

```bash
git log --oneline -1 origin/main
```

### Step 7: Register on StudyClawHub

Once pushed, ask the student: **"Would you like to register this on StudyClawHub now?"**

If yes, seamlessly hand off to the `submit` Skill workflow — build the
pre-filled GitHub Issue URL:

```
https://github.com/{STUDYCLAWHUB_REPO}/issues/new?title=register: {skill-name}&body={encoded_body}&labels=register
```

Where body includes: skill name, repo URL, path to skill folder, GitHub
username. Give the student the link and tell them to click Submit.

### Step 8: Optional next steps

Tell the student:

1. **Test it locally**: Install the Skill locally to try it out before
   others discover it on StudyClawHub.

## Tips for Writing Good Skills

Share these with the student:

- **Be specific in the description** — Include trigger phrases so the Skill
  activates reliably. E.g. "Use when user says 'analyze my network',
  'detect communities', 'analyze network'."
- **Don't over-engineer** — A Skill is just a prompt with metadata. Start
  simple, iterate later.
- **Think about edge cases** — What if the user gives incomplete input?
  What if an API call fails?
- **Use the student's course context** — Skills might involve graph analysis,
  sentiment analysis, influence detection, etc.

## Error Handling

- If the student gives a name that isn't kebab-case, auto-convert it
  (e.g. "Network Analyzer" → `network-analyzer`) and confirm.
- If the student isn't sure what env vars they need, help them figure it out
  based on what APIs or tools their Skill will use.
- If the student wants to use a binary that may not be commonly installed,
  suggest adding an `install` section to metadata.
