---
name: studyclawhub-search
description: "Search for Skills on StudyClawHub. Use when a student says 'search skills', 'find a skill about X', 'search StudyClawHub', '搜索skill', or '找skill'. Fetches the skills index, applies optional custom ranking, and displays results. Can open the StudyClawHub website with ranking parameters for visual browsing."
author: studyclawhub
version: 1.0.0
tags:
  - hub
  - search
  - discover
---

# StudyClawHub Search

You are helping a student search and discover Skills on StudyClawHub.

## Workflow

### Step 1: Get the query

Ask the student what they're looking for. They might say:
- A topic: "community detection", "graph visualization"
- A tag: "pagerank", "centrality"
- An author: "zhangsan"
- Or just "show me everything"

### Step 2: Fetch the index

Fetch `skills-index.json` from the StudyClawHub repo or website:

```
https://raw.githubusercontent.com/{STUDYCLAWHUB_REPO}/main/skills-index.json
```

Or if the `STUDYCLAWHUB_REPO` env var is set, use that.

### Step 3: Search and rank

Filter and rank the skills based on the query:

1. **Text match**: Match query against `name`, `description`, `tags`, and `author`
2. **Tag match**: Exact tag matches get boosted
3. **Default ranking**: Sort by relevance score, then by `registeredAt` (newest first)

If the student has a preferred ranker Skill installed locally, ask if they
want to use it for custom ranking.

### Step 4: Display results

Show results in a clear format:

```
1. [skill-name] by @author
   description text here
   Tags: tag1, tag2 | v1.0.0
   Repo: https://github.com/author/repo

2. [another-skill] by @author2
   ...
```

### Step 5: Offer visual browsing

After showing text results, offer to open the StudyClawHub website with
the search query pre-filled:

```
https://{STUDYCLAWHUB_PAGES_URL}/?q={query}
```

If the student has a custom ranker, include it:

```
https://{STUDYCLAWHUB_PAGES_URL}/?q={query}&ranker={author}/{repo}
```

This opens in CC's preview panel or the browser, showing the same results
with the custom ranking applied visually.

## Notes

- The search is intentionally simple (text matching). Students are encouraged
  to write their own search/ranking Skills with more sophisticated algorithms
  (PageRank, collaborative filtering, community detection, etc.) as part of
  the Social Network Mining course.
- Each student's ranking Skill is itself a course deliverable.
