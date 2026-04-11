---
name: sch-submit
description: "Submit your Skill to StudyClawHub. Use when a student says 'sch submit', 'submit to StudyClawHub', 'register on StudyClawHub', 'publish to sch', or 'sch publish'. Guides the student through validating their Skill folder and registering it via a GitHub Issue."
author: EnyanDai
version: 2.0.0
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

You are helping a student submit their Skill to the StudyClawHub registry.
No write access or fork is needed — registration is done via a GitHub Issue.

## Config

The StudyClawHub repo location. Check for the environment variable
`STUDYCLAWHUB_REPO`, or fall back to reading it from the student.
Format: `owner/repo` (e.g. `instructor/StudyClawHub`)

## Workflow

### Step 1: Locate and validate the Skill folder

Ask the student which folder contains their Skill. Read the `SKILL.md`
file in that folder and validate:

- [ ] `SKILL.md` exists
- [ ] YAML frontmatter has required fields: `name`, `description`
- [ ] Recommended fields present: `author`, `version`, `tags`
- [ ] If `metadata.openclaw` is present, validate that declared env vars / bins
      are actually referenced in the body
- [ ] `name` is kebab-case and URL-safe: `^[a-z0-9][a-z0-9-]*$`
- [ ] `author` matches their GitHub username
- [ ] `tags` has at least one tag
- [ ] `version` is valid semver

If validation fails, help the student fix the issues.

### Step 2: Push Skill to student's own GitHub repo

Check if the student's folder is in a Git repo with a remote:

```bash
git remote -v
```

**Case A — Already in a repo with a remote:**

Ensure changes are committed and pushed:

```bash
git add .
git commit -m "Update {skill-name}"
git push
```

**Case B — Not in a repo yet:**

```bash
git init
git add .
git commit -m "Initial commit: {skill-name}"
```

Then check if `gh` is available:

```bash
gh --version
```

**If `gh` is available**, create the repo and push in one command:

```bash
gh repo create {skill-name} --public --source=. --push
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

### Step 3: Register via GitHub Issue

Build a pre-filled Issue URL and give it to the student to open in their browser:

```
https://github.com/{STUDYCLAWHUB_REPO}/issues/new?title={encoded_title}&body={encoded_body}&labels=register
```

Where:
- `title` = `register: {skill-name}`
- `body` = the following (URL-encoded):
```
### Skill name

{skill-name}

### GitHub repo URL

{repo-url}

### Path to Skill folder

{path}

### Your GitHub username

{author}
```

Tell the student: "Open this link and click **Submit new issue**. That's it."

### Step 4: Confirm

Tell the student:
- A GitHub Action will automatically add their Skill to the registry
  and close the Issue.
- Their Skill will appear on the StudyClawHub website within minutes.
- No extra tools or permissions needed — just a GitHub account.

## Error Handling

- If the student's repo is private, warn them it must be public for
  the index builder to fetch SKILL.md.
- If a skill with the same name exists, the Action will update the
  existing entry instead of creating a duplicate.

## Notes

- Students own their Skill code in their own GitHub repo.
- StudyClawHub only stores a reference (repo URL + path).
- The entire registration flow requires zero permissions on the
  StudyClawHub repo — just a GitHub account to open an Issue.
