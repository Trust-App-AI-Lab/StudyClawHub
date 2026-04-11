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

Check if the student's folder is in a Git repo with a remote. If not:

1. `git init`
2. Guide to github.com/new to create a repo
3. Add remote, commit, push

If already in a repo, ensure changes are committed and pushed.
Record the full repo URL (e.g. `https://github.com/student/repo`).

### Step 3: Register via GitHub Issue

Create a GitHub Issue on the StudyClawHub repo. The student only needs
a GitHub account — no write access, no fork.

**Option A — Using `gh` CLI:**
```bash
gh issue create \
  --repo {STUDYCLAWHUB_REPO} \
  --title "register: {skill-name}" \
  --label "register" \
  --body "### Skill name

{skill-name}

### GitHub repo URL

{repo-url}

### Path to Skill folder

{path}

### Your GitHub username

{author}"
```

**Option B — If `gh` is not available:**
Provide the student a direct link to open a pre-filled issue:
```
https://github.com/{STUDYCLAWHUB_REPO}/issues/new?template=register-skill.yml&title=register:+{skill-name}
```
And tell them to fill in the 4 fields.

### Step 4: Confirm

Tell the student:
- Their registration Issue has been created.
- A GitHub Action will automatically validate the info, add it to
  `registry.json`, and close the Issue.
- Another Action will then fetch their SKILL.md metadata and rebuild
  the skills index.
- Their Skill will appear on the StudyClawHub website within minutes.

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
