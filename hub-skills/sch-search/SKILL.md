---
name: sch-search
description: "Search for Skills on StudyClawHub. Use when a student says 'sch search', 'search StudyClawHub', 'find a skill on sch', 'browse StudyClawHub', or 'sch find'. LLM-driven semantic search — fetches all skills, understands user intent, ranks by relevance."
author: EnyanDai
version: 0.1.0
tags:
  - hub
  - search
  - discover
metadata:
  openclaw:
    requires:
      bins:
        - curl
---

# StudyClawHub Search

You are helping a student search and discover Skills on StudyClawHub.
You (the LLM) are the search engine — read all skills, understand what
the student wants, and decide the best ranking yourself.

## Workflow

### Step 1: Get the query

Ask the student what they're looking for. They might say:
- A topic: "community detection", "graph visualization"
- A tag: "pagerank", "centrality"
- An author: "zhangsan"
- A vague need: "something to help me analyze networks"
- Or just "show me everything"

### Step 2: Fetch the index

If you already fetched `skills-index.json` earlier in this conversation,
reuse the cached result — do NOT fetch again. Unless the student explicitly
asks to refresh (e.g. "refresh", "重新拉", "latest", "最新的").

Otherwise, fetch it from:

```
https://trust-app-ai-lab.github.io/StudyClawHub/skills-index.json
```

Parse it as JSON. The `skills` array contains all registered skills with
fields: `name`, `description`, `tags`, `author`, `version`, `stars`,
`installs`, `registeredAt`, `repo`.

### Step 3: Read and rank

Read every skill's full information — name, description, and tags.
Use your understanding of the student's query to rank them by relevance.
Consider:

- Semantic relevance to the query (not just keyword matching)
- Quality of the description and documentation
- Stars and install counts as popularity signals
- Tag relevance
- How well the skill solves the student's actual need

You decide the final order. There is no external ranking algorithm —
you are the ranker.

### Step 4: Display results in CLI

Show the top results in a clear format:

```
1. [skill-name] by @author  ★3 ↓12
   description text here
   Tags: tag1, tag2 | v1.0.0

2. [another-skill] by @author2  ★1 ↓5
   ...
```

Briefly explain why you ranked them this way if it's not obvious.

### Step 5: Offer next steps

After showing results, offer the student:
- `/sch-install {name}` to install a skill
- Link to the skill's GitHub repo for more details
