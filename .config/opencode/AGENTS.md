## Conventions
- NEVER use bash commands (sed, awk, perl, cat, echo, printf, tee, etc.) to edit files. ALWAYS use the built-in edit and write tools so that every change produces a visible diff in the UI. The human operator must be able to see exactly what is being changed. If you need to make a file change, use the edit tool — no exceptions.
- All new code must have tests where applicable
- Use conventional commits
- NEVER modify packages or directories you weren't asked to modify
- Run relevant linters/tests in the affected area after changes

## Context Boundaries
- The `thoughts/codebase-analysis-*/` directory is a knowledge base managed EXCLUSIVELY by the codebase-analyzer primary agent.
- NO other agent should read, load, or reference files in `thoughts/codebase-analysis-*/` — not the build agent, not the orchestrator, not any subagent.
- If you need architectural knowledge during a workflow, use Engram (`mem_search`). The codebase-analyzer saves key findings to Engram specifically so other agents can access that knowledge without loading the full analysis files.
- The only thoughts/ files other agents may touch are the active workflow files (`thoughts/{slug}/`) and ONLY when `thoughts/.active-workflow` exists.

## Primary Agents (Tab to switch)
- **build**: Everyday agent. Quick questions, small tasks, debugging, conversations. (default)
- **plan**: Read-only analysis. Code review suggestions, architecture discussion. No file changes.
- **orchestrator**: Full Research → Plan → Implement → Review workflow. Use in worktrees for features.
- **codebase-analyzer**: Interactive codebase learning. Broad overviews, focused deep dives, re-analysis when things change. Use for onboarding or ongoing product understanding.

## Available Subagents
When delegating with the task tool, prefer the most specific agent for the job:

### Planning & Research
- **planner**: Strategic planning. Creates detailed implementation plans. Uses Claude Opus. (temp 0.3)
- **researcher**: Read-only research. Targeted investigation for a specific feature or task. Finds patterns, file paths, conventions. (temp 0.1)

### Domain-Specific Implementation
- **golang**: Principal Go engineer. Idiomatic Go, concurrency, stdlib-quality code. Uses Claude Sonnet. (temp 0.2)
- **platform**: DevOps/infra. Terraform, Ansible, CI/CD, Dockerfiles, Makefiles, shell. (temp 0.2)
- **k8s**: Kubernetes expert. Manifests, Helm, Kustomize, cloud-native patterns. (temp 0.2)

### General Implementation
- **implementer**: Catch-all for Python, Chef, Ruby, TypeScript, or anything without a dedicated specialist. (temp 0.2)

### Quality Gates (read-only)
- **reviewer**: Principal architect. Code quality, DRY, complexity, performance. Uses Claude Opus. (temp 0.1)
- **security**: AppSec engineer. OWASP, secrets scanning, dependency CVEs, infra misconfig. (temp 0.0)

### Testing & Fixes
- **tester**: Senior test engineer. TDD RED phase, edge cases, boundary values. (temp 0.2)
- **quick-fix**: Typos, imports, lint errors. Fast and cheap. (temp 0.1)

### Utility
- **explore**: Fast codebase grep (built-in). Used by other agents for quick file/pattern discovery. You can also invoke directly for quick lookups.

### Agent Selection Guide
- Go code → @golang (not @platform)
- Helm/K8s manifests → @k8s (not @platform)
- Terraform/Ansible/Docker/CI → @platform
- Python/Chef/Ruby/TypeScript → @implementer (catch-all)
- No dedicated specialist exists → @implementer
- Security audit → @security then @reviewer
- Code quality review → @reviewer
- Quick file/pattern lookup → @explore
- Always run @security on auth-related, secrets-related, or network-related changes
- Onboarding to a product/domain → Tab to codebase-analyzer (primary agent, NOT a subagent)

### Agent Zoom Levels
- **@explore** → "find me files matching this pattern RIGHT NOW" (magnifying glass)
- **@researcher** → "what do I need to know to implement THIS FEATURE?" (focused investigation)
- **codebase-analyzer** (Tab to it) → "help me understand THIS PRODUCT from scratch" (full map, interactive)

## Thoughts Directory Philosophy
The thoughts/ directory contains workflow artifacts organized per feature:
```
thoughts/
  .active-workflow              ← single marker file at root (one line: the slug)
  {slug}/
    research/
      research-{slug}.md        ← main research findings
      research-{slug}-*.md      ← additional subtopic research
    plan/
      plan-{slug}.md            ← main implementation spec
      plan-{slug}-*.md          ← sub-plans for complex features
    progress/
      progress-{slug}.md        ← main progress tracker
      progress-{slug}-*.md      ← per-phase or per-task progress
```

Codebase analysis lives separately (managed only by codebase-analyzer):
```
thoughts/
  codebase-analysis-{product-slug}/
    overview.md                 ← product-level architecture
    areas/
      {area-slug}.md            ← deep dive per area
    services/
      {service-name}.md         ← per-service breakdown
    changelog.md                ← log of analysis sessions
```

### research/ — What we learned
Source of truth for research findings. Update only if new findings emerge.

### plan/ — What we are implementing
Source of truth for the IMPLEMENTATION SPEC. ONLY update if the approach, scope, or technical details change. NEVER mark tasks complete. NEVER add progress. Always reads as a clean spec.

### progress/ — Where we are / what happened
Source of truth for PROGRESS and OUTCOMES. Tracks: completed tasks, in-progress state, blockers, deviations, what to resume next. Update freely.

## Persistent Memory (Engram)
Before ANY memory SAVE operation (mem_save, mem_session_summary), ALWAYS load the engram-protocol skill first. No exceptions.

**CRITICAL: Do NOT save memories proactively.** NEVER call mem_save or mem_session_summary on your own initiative. Only save memories when:
- The user explicitly says "save that to memory", "remember this", or similar
- The user runs /remember
- The user runs /wrapup or says "wrap up", "land the plane", "save and close", "end session", "signing off", "done for the day"

Memory RETRIEVAL (mem_search) is fine at any time when it would help answer the user.
You have access to Engram memory tools via MCP. USE THEM.
ALWAYS load the engram-protocol skill BEFORE any memory operation. Do not call mem_save or mem_session_summary without loading the skill first. No exceptions.

### Title Format (CRITICAL)
Always use: `{Type}: {Specific Subject} — {Key Detail}`
Type prefixes: Root cause, Decision, Pattern, Architecture, Gotcha, Process, Preference, Config, Deprecated

### GOOD title: "Root cause: storage-lb OOM in production — unbounded goroutine leak in handler.go"
### BAD title: "found something" or "auth stuff" or "important note"

### Content Format
Always structure content with: **What**, **Why**, **Where**, **Impact**, **Date**

### When to SAVE:
- A decision was made and the reasoning should persist
- A root cause was found after debugging
- A non-obvious pattern or convention was discovered
- An architecture insight was learned
- A gotcha or non-obvious behavior was encountered
- A user preference was stated

### When NOT to save:
- Step-by-step procedures (use SKILLS instead)
- Temporary debugging notes
- Things already in AGENTS.md or committed docs
- Vague observations without specifics
- Duplicates of existing memories (update with SUPERSEDES instead)

### Staleness
When a memory is outdated, save a NEW memory with the same subject keywords.
Start content with: "UPDATED {date} — replaces earlier memory on this topic."
When search returns multiple memories on the same topic, ALWAYS use the most recent. No tombstones. No second memory to invalidate. Just one clean replacement.

### Save Frequency
- 1-hour debugging session: 1-3 memories
- Feature implementation: 2-5 memories
- More than 5 per session: too granular
- Zero per session: you probably missed something

### Memory Retrieval:
When the user asks about a topic and you suspect there may be relevant context from previous sessions, suggest using /retrieve. Do NOT automatically search memory at session start. Let the user decide when to pull in past context. However, ALWAYS check if thoughts/.active-workflow exists at session start — if it does, mention it to the user so they know there is an in-progress workflow.

### Session Close Trigger
When the user says any of the following, it means they are ending the session:
- "wrap up"
- "land the plane"
- "save and close"
- "end session"
- "signing off"
- "done for the day"

When you detect this, IMMEDIATELY:

**Check thoughts/.active-workflow first.**

If it DOES NOT EXIST: this session has no orchestrator workflow. Skip straight to memory saves. Do NOT touch any thoughts/ files.

If it EXISTS: read the slug. ONLY touch files inside thoughts/{slug}/:
1. Plan files (thoughts/{slug}/plan/) — ONLY update if implementation details actually changed. Not for progress.
2. Progress files (thoughts/{slug}/progress/) — Update with completed tasks, current state, blockers, what to resume.
3. Do NOT delete .active-workflow unless all tasks are complete.
4. Do NOT touch other slug directories.

**Always (regardless of workflow):**
1. Call mem_session_summary with: goal, accomplishments, decisions, remaining work, files touched
2. Call mem_save for any decisions, discoveries, or root causes not already saved — follow the engram-protocol title and content format
3. If resuming work next session, include clear next-step context in the memory
4. Confirm to the user what was saved and updated

## Validation Commands by File Type
- **Go (.go)**: LSP diagnostics are automatic. Run `go test ./...` and `go vet ./...`
- **Python (.py)**: LSP diagnostics are automatic. Run `pytest` and `ruff check .`
- **Ansible (.yml playbooks)**: Run `ansible-lint` via bash
- **Helm charts**: Run `helm lint <chart-dir>` and `helm template <chart-dir>`
- **Chef (recipes/cookbooks)**: Run `cookstyle` via bash
- **Dockerfiles**: LSP diagnostics are automatic. Run `hadolint <Dockerfile>` if available
- **YAML/JSON (GHA pipelines, configs)**: LSP diagnostics are automatic
- **Makefiles**: Run `make -n <target>` (dry run)
- **HCL / Vault policies**: Run `vault policy fmt <file>`
- **Shell scripts (.sh)**: Run `shellcheck <file>` if available

## When using context7
Add "use context7" to prompts when you need current library documentation.
