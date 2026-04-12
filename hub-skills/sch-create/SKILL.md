---
name: sch-create
description: "Create or adapt a Skill for StudyClawHub / ClawHub. Use when a student says 'sch create', 'create a skill', 'adapt my skill', 'convert to skill format', '适配skill', '创建skill', 'make my project a skill', 'wrap as skill', or wants to turn an existing project into a ClawHub-compatible Skill."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - create
  - scaffold
  - adapt
metadata:
  openclaw:
    requires:
      bins:
        - git
      anyBins:
        - gh
---

# StudyClawHub Create / Adapt

You are helping a student either **adapt an existing project** into a
ClawHub-compatible Skill, or **create a new Skill from scratch**. The primary
use case is adaptation — most students already have working code and just need
it packaged correctly.

## Step 0: Determine Mode

Ask the student one question:

> Do you already have code / a project you want to turn into a Skill, or do
> you want to start from scratch?

- **"I have existing code"** → go to **Path A: Adapt Existing Project**
- **"Start from scratch"** → go to **Path B: Create New Skill**

If the student's working directory already contains code files, default to
Path A and confirm.

---

## Path A: Adapt Existing Project (Primary)

### A1: Understand the project

Scan the student's project directory. Read key files (README, main scripts,
config files, etc.) to understand:

1. **What it does** — Summarize the functionality in one sentence.
2. **How it's triggered** — What user intents or commands activate it?
3. **Dependencies** — Does it need env vars (API keys), CLI tools, or
   packages?
4. **Existing structure** — Where the main logic lives, what files are
   essential vs auxiliary.

Share your understanding with the student and confirm it's accurate before
proceeding.

### A2: Determine Skill folder layout

The Skill must live in a single folder:

```
{skill-name}/
├── SKILL.md          ← Required
└── (supporting files) ← Scripts, examples, references, etc.
```

Discuss with the student:

- If the whole repo IS the skill → SKILL.md goes at repo root.
- If the skill is a subfolder of a larger repo → identify which folder.
- Files must be text-based (.md, .js, .ts, .py, .json, .yaml, .txt, .csv,
  .svg). No binaries in the Skill folder.

### A3: Generate SKILL.md

Based on what you learned in A1, generate a complete `SKILL.md`. Don't ask
the student to fill in each field one by one — **draft it yourself** based on
your analysis, then let them review and refine.

#### Frontmatter format

```yaml
---
name: {skill-name}
description: "{one-line description — include trigger phrases}"
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

**Frontmatter rules:**

- `name`: Kebab-case, URL-safe: `^[a-z0-9][a-z0-9-]*$`
- `description`: One line, quoted. Explain what it does AND when to trigger
  it. Include common trigger phrases in both English and Chinese if the
  student is from a Chinese-language course.
- `author`: Student's GitHub username.
- `version`: `1.0.0` for new skills, or match existing version if the
  project already has one.
- `tags`: At least one tag, lowercase, related to the skill's domain.
- `metadata.openclaw`: Only include if the skill actually needs env vars,
  binaries, or dependencies. Omit entirely for pure-prompt skills.

#### Body content

After the frontmatter, write clear Markdown instructions that tell Claude /
the agent how to execute the Skill. Include:

1. **One-line role statement** — "You are helping the user do X."
2. **When to trigger** — User intents that activate this Skill.
3. **Step-by-step workflow** — Numbered steps with clear actions.
4. **Input/output format** — What the Skill expects and produces.
5. **Error handling** — Common failure modes and recovery.
6. **Examples** (optional) — Sample interactions.

**Important:** Don't generate a generic template. Tailor the body to the
student's actual project — reference their real files, real functions, real
use cases.

### A4: Create supporting files (if needed)

If the Skill needs helper scripts, example data, or reference files, create
or reorganize them in the Skill folder. Common patterns:

- `examples/` — Sample input/output
- `templates/` — Template files
- `lib/` — Helper scripts

### A5: Validate

Check the generated Skill:

- [ ] `SKILL.md` exists with valid YAML frontmatter
- [ ] `name` is kebab-case and URL-safe
- [ ] `description` is present and meaningful, includes trigger phrases
- [ ] `author` matches student's GitHub username
- [ ] `version` is valid semver
- [ ] `tags` has at least one tag
- [ ] `metadata.openclaw.requires.env` — declared vars are actually used
- [ ] `metadata.openclaw.requires.bins` — declared binaries are actually used
- [ ] Body has clear step-by-step instructions tailored to the project
- [ ] No binary files in the Skill folder

→ Proceed to **Step 1: Git & GitHub (Optional)**.

---

## Path B: Create New Skill (From Scratch)

### B1: Understand what the student wants to build

Ask the student:

1. **What does your Skill do?** — Get a clear description of the
   functionality.
2. **What should it be called?** — Suggest a kebab-case name based on their
   description if they're unsure.
3. **Does it need any external tools or APIs?** — Env vars, CLI tools,
   package dependencies?

### B2: Choose a location

Ask where to create the Skill folder:

- Inside an existing project repo, or
- A new folder they can later push to GitHub.

### B3: Generate SKILL.md and supporting files

Follow the same frontmatter rules and body content guidelines as Path A
(sections A3 and A4). Write the body collaboratively with the student —
ask about their specific use case and tailor the instructions accordingly.

### B4: Validate

Run the same validation checklist as Path A (section A5).

→ Proceed to **Step 1: Git & GitHub (Optional)**.

---

## Step 1: Git & GitHub (Optional)

Ask the student: **"Would you like to push this to GitHub now, or keep it
local for now?"**

If the student wants to **keep it local** → skip to Step 2.

If the student wants to **push to GitHub**:

First check the current state:

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

**Case B — Not in a git repo yet:**

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

**If `gh` is available:**

```bash
gh repo create {skill-name} --public --source=. --push
```

If `gh auth status` shows not logged in, run `gh auth login` first.

**If `gh` is NOT available:**

1. Tell the student to open `https://github.com/new` in their browser.
2. Repo name: suggest using the skill name.
3. Must be **Public**. Do NOT initialize with README.
4. After the student creates the repo and gives the URL:

```bash
git remote add origin https://github.com/{username}/{repo}.git
git branch -M main
git push -u origin main
```

**Verify** the push succeeded:

```bash
git log --oneline -1 origin/main
```

## Step 2: Register on StudyClawHub (Optional)

If the student has pushed to GitHub, ask:
**"Would you like to register this on StudyClawHub now?"**

If yes → hand off to the **sch-submit** Skill. Tell the student to run
`/sch-submit` (or the equivalent command for their platform) and follow
its workflow.

If the student hasn't pushed to GitHub yet, let them know they can register
later once they do.

## Tips for Writing Good Skills

Share these with the student:

- **Be specific in the description** — Include trigger phrases so the Skill
  activates reliably. E.g. "Use when user says 'analyze my network',
  'detect communities'."
- **Don't over-engineer** — A Skill is just a prompt with metadata. Start
  simple, iterate later.
- **Think about edge cases** — What if the user gives incomplete input?
  What if an API call fails?
- **Test locally first** — Install the Skill locally and try it before
  publishing.

## Error Handling

- If the student gives a name that isn't kebab-case, auto-convert it
  (e.g. "Network Analyzer" → `network-analyzer`) and confirm.
- If the student isn't sure what env vars they need, help them figure it out
  based on what APIs or tools their Skill will use.
- If the student wants to use a binary that may not be commonly installed,
  suggest adding an `install` section to metadata.
