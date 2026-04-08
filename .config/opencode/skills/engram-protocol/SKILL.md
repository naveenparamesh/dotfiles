---
name: engram-protocol
description: >
  Standards for saving, updating, and maintaining Engram memories.
  Referenced by all agents via AGENTS.md.
---

# Engram Memory Protocol

## Title Format (CRITICAL for retrieval)

Titles must be keyword-rich and follow this pattern:

  {Type}: {Specific Subject} — {Key Detail}

### Examples of GOOD titles:
  Root cause: storage-lb OOM in production — unbounded goroutine leak in handler.go
  Decision: chose Vault sidecar over direct API — lower latency, simpler auth rotation
  Pattern: all Helm values files use values-{env}.yaml naming in spaces-api
  Gotcha: storage-staging.json not staging-storage.json in chef environments dir
  Architecture: billing webhook calls Vault synchronously — blocks on token refresh
  Preference: user wants small PRs, max 200 lines changed per PR

### Examples of BAD titles (unfindable):
  found something
  important note
  auth stuff
  remember this
  fix

### Type prefixes (use one):
  Root cause:    — why something broke
  Decision:      — a choice that was made and why
  Pattern:       — a recurring convention or structure
  Architecture:  — how systems connect or communicate
  Gotcha:        — something non-obvious that causes confusion
  Process:       — a workflow or operational detail
  Preference:    — a user or team preference
  Config:        — an important configuration detail

## Content Format

Content should be structured, not a wall of text:

  **What**: One sentence describing the fact or decision.
  **Why**: The reasoning or root cause.
  **Where**: File paths, service names, or specific locations.
  **Impact**: What depends on this or what breaks if it changes.
  **Date**: When this was learned or decided.

## Staleness Protocol

Engram has no edit or delete via MCP. When a memory is outdated:

1. Save a NEW memory with the corrected info using the SAME subject keywords
   so it surfaces alongside the old one in search
2. Start the content with: "UPDATED {date} — replaces earlier memory on this topic."
3. Include the corrected facts in full — do not reference the old memory
4. When search returns multiple memories on the same topic, ALWAYS use the one
   with the most recent date. Ignore older entries on the same subject.

That's it. One new memory. No tombstones. No second memory just to invalidate.

The user can periodically clean the database manually if needed:
  sqlite3 ~/.engram/engram.db "SELECT id, title FROM observations;"
  sqlite3 ~/.engram/engram.db "DELETE FROM observations WHERE id = <id>;"

## What NOT to Save

Do NOT save:
- Step-by-step procedures (use SKILLS instead — deterministic, not fuzzy search)
- Temporary debugging notes ("tried adding a print statement")
- Things already in AGENTS.md, README, or committed documentation
- Vague observations without specifics ("the code seems messy")
- Duplicate information already in a previous memory (supersede it instead)
- Raw file contents or code blocks (just reference the file path)

## Save Frequency

- A typical 1-hour debugging session: 1-3 memories
- A typical feature implementation: 2-5 memories
- More than 5 per session: probably too granular
- Zero per session: you probably learned something worth saving
