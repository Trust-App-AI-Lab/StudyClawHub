---
name: studyclawhub-submit
description: "Submit your Skill to StudyClawHub. Use when a student says 'submit my skill', 'publish to StudyClawHub', 'register my skill', '提交skill', or '发布skill'. Guides the student through validating their Skill folder, pushing to their own GitHub repo, and registering it via a GitHub Issue."
author: EnyanDai
version: 2.0.0
tags:
  - hub
  - submit
  - publish
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
- [ ] YAML frontmatter has required fields: `name`, `description`, `author`, `version`, `tags`
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

**If already in a repo with a remote:** ensure changes are committed and pushed.

**If not in a repo:** run the following for the student:

```bash
git init
git add .
git commit -m "Initial commit"
```

Then tell the student to create a repo on GitHub:
- Open this link in their browser: `https://github.com/new`
- Repo name can be anything, must be **Public**
- Do NOT initialize with README

After the student creates the repo and gives you the URL, run:

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
