---
name: studyclawhub-submit
description: "Submit your Skill to StudyClawHub. Use when a student says 'submit my skill', 'publish to StudyClawHub', 'register my skill', '提交skill', or '发布skill'. Guides the student through validating their Skill folder, pushing to their own GitHub repo, and registering it with the StudyClawHub registry."
author: studyclawhub
version: 1.0.0
tags:
  - hub
  - submit
  - publish
---

# StudyClawHub Submit

You are helping a student submit their Skill to the StudyClawHub registry.

## Workflow

### Step 1: Locate the Skill folder

Ask the student which folder contains their Skill. Read the `SKILL.md` file
in that folder and validate:

- [ ] `SKILL.md` exists
- [ ] YAML frontmatter has all required fields: `name`, `description`, `author`, `version`, `tags`
- [ ] `name` is kebab-case and URL-safe: `^[a-z0-9][a-z0-9-]*$`
- [ ] `author` matches their GitHub username
- [ ] `tags` has at least one tag
- [ ] `version` is valid semver

If validation fails, help the student fix the issues.

### Step 2: Push to GitHub

Check if the student's folder is in a Git repo. If not, help them:

1. Initialize a git repo: `git init`
2. Create a GitHub repo (guide them to github.com/new)
3. Add remote, commit, and push

If already in a repo, ensure changes are committed and pushed.

### Step 3: Register with StudyClawHub

The student needs to add their Skill to StudyClawHub's `registry.json`.

1. Clone or fetch the StudyClawHub repo (the STUDYCLAWHUB_REPO environment variable
   should contain the repo URL, e.g. `https://github.com/instructor/StudyClawHub`)
2. Read the current `registry.json`
3. Add a new entry:
   ```json
   {
     "name": "skill-name",
     "repo": "https://github.com/student/repo",
     "path": "path/to/skill-folder",
     "author": "github-username",
     "registeredAt": "ISO-8601 timestamp"
   }
   ```
4. Commit and push (student must have write access to StudyClawHub repo)

### Step 4: Confirm

Tell the student their Skill has been registered. The GitHub Actions workflow
will automatically fetch metadata and update `skills-index.json`. Their Skill
will appear on the StudyClawHub website within a few minutes.

## Error Handling

- If the student doesn't have write access to StudyClawHub, tell them to
  ask the instructor for collaborator access.
- If a skill with the same `name` already exists in the registry, warn and
  ask if they want to update the existing entry.

## Notes

- Students own their Skill code in their own repo. StudyClawHub only stores
  a reference (the repo URL and path).
- The `ranker.js` file, if present, will be picked up by the website for
  custom search ranking.
