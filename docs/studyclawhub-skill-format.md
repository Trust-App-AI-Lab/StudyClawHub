# StudyClawHub Skill Format

## Overview

A Skill is a folder in a GitHub repository. Students host Skills in their own repos
and register them with StudyClawHub.

## Required Structure

```
my-skill/
├── SKILL.md          ← Required. Frontmatter metadata + instructions.
└── (any other files)  ← Optional. References, scripts, examples, ranker.js, etc.
```

## SKILL.md

Markdown file with YAML frontmatter.

### Required Frontmatter

```yaml
---
name: my-skill-name
description: "One-line summary of what this Skill does."
author: github-username
version: 1.0.0
tags:
  - community-detection
  - graph-analysis
---
```

### Full Field Reference

| Field         | Type       | Required | Description                                    |
| ------------- | ---------- | -------- | ---------------------------------------------- |
| `name`        | `string`   | Yes      | Kebab-case identifier, URL-safe                |
| `description` | `string`   | Yes      | Short summary shown in search results          |
| `author`      | `string`   | Yes      | GitHub username of the author                  |
| `version`     | `string`   | Yes      | Semver version string                          |
| `tags`        | `string[]` | Yes      | Category tags for filtering/search             |
| `repo`        | `string`   | No       | GitHub repo URL (auto-filled by submit Skill)  |
| `ranker`      | `boolean`  | No       | If true, this Skill provides a `ranker.js`     |

### Body

After the frontmatter, write the Skill instructions in Markdown. This is what
Claude/OpenClaw will read when the Skill is activated.

## Optional: ranker.js

If your Skill provides a custom search ranking algorithm, include a `ranker.js`
in the root of your Skill folder. It must export a single function:

```js
// ranker.js
export default function rank(skills, query) {
  // skills: Array<{ name, description, author, tags, ... }>
  // query: string (search query)
  // return: sorted Array of skills
}
```

The StudyClawHub website and search Skill will load this function to re-rank
search results.

## Example

```yaml
---
name: pagerank-search
description: "Ranks Skills by PageRank score based on cross-references."
author: zhangsan
version: 1.0.0
tags:
  - search
  - pagerank
  - ranking
ranker: true
---

# PageRank Search

This Skill ranks StudyClawHub skills using the PageRank algorithm...
```

## Slugs

- Derived from the `name` field.
- Must be lowercase and URL-safe: `^[a-z0-9][a-z0-9-]*$`.

## Allowed Files

Any text-based files: `.md`, `.js`, `.ts`, `.py`, `.json`, `.yaml`, `.txt`, `.csv`, `.svg`.
Binary files (images, zips) should not be included in the Skill folder itself.
