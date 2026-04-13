---
name: sch-delete
description: "Delete a Skill or Agent from StudyClawHub. Use when a student says 'sch delete', 'delete skill', 'remove from StudyClawHub', 'unregister skill', or '删除skill'."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - delete
  - remove
metadata:
  openclaw:
    requires:
      bins:
        - git
      anyBins:
        - gh
---

# StudyClawHub Delete

You are helping a student delete a Skill or Agent from StudyClawHub.

## Config

StudyClawHub repo: `Trust-App-AI-Lab/StudyClawHub`

## Workflow

### Step 1: Identify the Skill to delete

The student provides a skill name. If unsure, help them look it up:

```bash
curl -fsSL https://trust-app-ai-lab.github.io/StudyClawHub/skills-index.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
for s in data: print(f\"{s['name']}  ({s.get('type','skill')})  by {s.get('author','?')}\")
"
```

### Step 2: Confirm with the student

Show them what will be deleted:
- Skill/Agent name and author
- If it's an agent, warn that **all child skills** will also be removed

Ask the student to confirm before proceeding.

### Step 3: Delete via GitHub Issue

**If `gh` is available:**

```bash
gh issue create \
  --repo Trust-App-AI-Lab/StudyClawHub \
  --title "delete: {skill-name}" \
  --body "Requesting deletion of {skill-name} from registry."
```

Then wait for the issue to be closed:

```bash
gh issue view {number} --repo Trust-App-AI-Lab/StudyClawHub --json state --jq .state
```

**If `gh` is NOT available**, give the student a pre-filled URL:

```
https://github.com/Trust-App-AI-Lab/StudyClawHub/issues/new?title=delete:%20{skill-name}&body=Requesting%20deletion%20of%20{skill-name}%20from%20registry.
```

### Step 4: Confirm

Tell the student:
- The GitHub Action will remove the entry from the registry and close
  the issue automatically.
- Only the skill's author or repo admins can delete a skill.
- The skill will disappear from the website after the index rebuilds.

## Error Handling

- If the student is not the author and not a repo admin, the Action
  will deny the request and close the issue with an error comment.
- If the skill name is not found in the registry, the Action will
  report it and close the issue.
