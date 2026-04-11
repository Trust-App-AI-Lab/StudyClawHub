---
name: my-skill-name
description: "One-line summary. Include trigger phrases, e.g. Use when user says 'do X', 'run Y'."
author: your-github-username
version: 1.0.0
tags:
  - tag1
  - tag2
metadata:
  openclaw:
    requires:
      env:
        - MY_API_KEY
      bins:
        - python3
    primaryEnv: MY_API_KEY
---

# My Skill Name

You are helping the user do X.

## When to trigger

Activate when the user says "do X", "run Y", or similar.

## Workflow

### Step 1: Gather input

Ask the user for the required information.

### Step 2: Execute

Perform the main task.

### Step 3: Present results

Show the output to the user.

## Error handling

- If input is missing, ask the user to provide it.
- If an API call fails, retry once, then report the error.
