---
description: End session. Save progress and memories.
template: >
  Load the engram-protocol skill first. Follow it for ALL memory saves below.

  I am ending this session now. Do ALL of the following BEFORE responding:


  ## Step 1: Check for active orchestrator workflow

  Check if thoughts/.active-workflow exists.


  If the file DOES NOT EXIST: skip straight to Step 2. This session was not
  running an orchestrator workflow. Do NOT touch any thoughts/ files.


  If the file EXISTS: read the slug from it. This session's workflow lives in
  thoughts/{slug}/. ONLY touch files inside that directory.


  ### Plan files (thoughts/{slug}/plan/) — ONLY update if implementation details changed

  ONLY update if the approach, scope, or technical details actually changed during
  this session. Do NOT mark tasks complete. Do NOT add progress. Plans should always
  read as a clean implementation spec.


  ### Progress files (thoughts/{slug}/progress/) — ALWAYS update

  Create or update thoughts/{slug}/progress/progress-{slug}.md with: completed tasks,
  in-progress state, blockers, problems, deviations from plan, what to resume next session.


  ### Do NOT delete thoughts/.active-workflow unless ALL tasks are complete.

  ### Do NOT touch thoughts/ directories belonging to other slugs.


  ## Step 2: Save to persistent memory (ALWAYS do this, follow engram-protocol skill)

  1. Call mem_session_summary with: goal, accomplishments, decisions made, remaining
  work, key files touched or discussed

  2. Call mem_save for any individual decisions, discoveries, root causes, or patterns
  not already saved. Use engram-protocol title format: {Type}: {Subject} — {Detail}.
  Use engram-protocol content format: **What**, **Why**, **Where**, **Impact**, **Date**.

  3. If there IS an active workflow with remaining tasks, include in mem_save which tasks
  are done, which are next, and context for the next session


  ## Step 3: Confirm

  Tell me what was saved and updated.


  This is not optional. Do all steps before responding.
---
