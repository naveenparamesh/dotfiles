/**
 * Engram — OpenCode plugin adapter (modified)
 *
 * Modified: removed auto-save behavior, passive capture, and prompt capture.
 * Kept: session tracking, compaction recovery, context injection.
 * Memory saves only happen when explicitly triggered by user.
 */

import type { Plugin } from "@opencode-ai/plugin"

const ENGRAM_PORT = parseInt(process.env.ENGRAM_PORT ?? "7437")
const ENGRAM_URL = `http://127.0.0.1:${ENGRAM_PORT}`
const ENGRAM_BIN = process.env.ENGRAM_BIN ?? "engram"

const ENGRAM_TOOLS = new Set([
  "mem_search", "mem_save", "mem_update", "mem_delete",
  "mem_suggest_topic_key", "mem_save_prompt", "mem_session_summary",
  "mem_context", "mem_stats", "mem_timeline", "mem_get_observation",
  "mem_session_start", "mem_session_end",
])

// Retrieval-only instructions — no auto-save directives
const MEMORY_INSTRUCTIONS = `## Engram Persistent Memory

You have access to Engram, a persistent memory system that survives across sessions and compactions.

### RETRIEVAL
- Use \`mem_search\` when the user asks to recall something or when context from past sessions would help.
- Use \`mem_context\` for recent session history.
- Use \`mem_get_observation\` for full untruncated content of a specific memory.

### SAVING
- Do NOT save memories automatically or proactively.
- ONLY save when the user explicitly asks (e.g., "save that to memory", "remember this", /remember, /wrapup, "wrap up", "land the plane").
- When saving, follow the engram-protocol skill for title and content format.

### AFTER COMPACTION
If you see a message about compaction or context reset, or if you see "FIRST ACTION REQUIRED" in your context:
1. Call \`mem_context\` to recover context from previous sessions.
2. Then continue working.
`

async function engramFetch(
  path: string,
  opts: { method?: string; body?: any } = {}
): Promise<any> {
  try {
    const res = await fetch(`${ENGRAM_URL}${path}`, {
      method: opts.method ?? "GET",
      headers: opts.body ? { "Content-Type": "application/json" } : undefined,
      body: opts.body ? JSON.stringify(opts.body) : undefined,
    })
    return await res.json()
  } catch {
    return null
  }
}

async function isEngramRunning(): Promise<boolean> {
  try {
    const res = await fetch(`${ENGRAM_URL}/health`, {
      signal: AbortSignal.timeout(500),
    })
    return res.ok
  } catch {
    return false
  }
}

function extractProjectName(directory: string): string {
  try {
    const result = Bun.spawnSync(["git", "-C", directory, "remote", "get-url", "origin"])
    if (result.exitCode === 0) {
      const url = result.stdout?.toString().trim()
      if (url) {
        const name = url.replace(/\.git$/, "").split(/[/:]/).pop()
        if (name) return name
      }
    }
  } catch {}
  try {
    const result = Bun.spawnSync(["git", "-C", directory, "rev-parse", "--show-toplevel"])
    if (result.exitCode === 0) {
      const root = result.stdout?.toString().trim()
      if (root) return root.split("/").pop() ?? "unknown"
    }
  } catch {}
  return directory.split("/").pop() ?? "unknown"
}

export const Engram: Plugin = async (ctx) => {
  const oldProject = ctx.directory.split("/").pop() ?? "unknown"
  const project = extractProjectName(ctx.directory)
  const knownSessions = new Set<string>()

  async function ensureSession(sessionId: string): Promise<void> {
    if (!sessionId || knownSessions.has(sessionId)) return
    knownSessions.add(sessionId)
    await engramFetch("/sessions", {
      method: "POST",
      body: { id: sessionId, project, directory: ctx.directory },
    })
  }

  const running = await isEngramRunning()
  if (!running) {
    try {
      Bun.spawn([ENGRAM_BIN, "serve"], {
        stdout: "ignore", stderr: "ignore", stdin: "ignore",
      })
      await new Promise((r) => setTimeout(r, 500))
    } catch {}
  }

  if (oldProject !== project) {
    await engramFetch("/projects/migrate", {
      method: "POST",
      body: { old_project: oldProject, new_project: project },
    })
  }

  try {
    const manifestFile = `${ctx.directory}/.engram/manifest.json`
    const file = Bun.file(manifestFile)
    if (await file.exists()) {
      Bun.spawn([ENGRAM_BIN, "sync", "--import"], {
        cwd: ctx.directory, stdout: "ignore", stderr: "ignore", stdin: "ignore",
      })
    }
  } catch {}

  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        const sessionId = (event.properties as any)?.id
        if (sessionId) await ensureSession(sessionId)
      }
      if (event.type === "session.deleted") {
        const sessionId = (event.properties as any)?.id
        if (sessionId) knownSessions.delete(sessionId)
      }
      // REMOVED: prompt capture on message.updated
    },

    // REMOVED: passive capture in tool.execute.after
    // Only track session for ensureSession, no data capture
    "tool.execute.after": async (input, _output) => {
      if (ENGRAM_TOOLS.has(input.tool.toLowerCase())) return
      const sessionId = input.sessionID
      if (sessionId) await ensureSession(sessionId)
    },

    // System prompt: retrieval-only instructions (no auto-save directives)
    "experimental.chat.system.transform": async (_input, output) => {
      if (output.system.length > 0) {
        output.system[output.system.length - 1] += "\n\n" + MEMORY_INSTRUCTIONS
      } else {
        output.system.push(MEMORY_INSTRUCTIONS)
      }
    },

    // Compaction: inject context recovery (KEPT — this is valuable)
    "experimental.session.compacting": async (input, output) => {
      if (input.sessionID) await ensureSession(input.sessionID)

      const data = await engramFetch(
        `/context?project=${encodeURIComponent(project)}`
      )
      if (data?.context) output.context.push(data.context)

      // Tell compressor to instruct new agent to recover context
      output.context.push(
        `INSTRUCTION FOR COMPACTED SUMMARY:\n` +
        `The agent has access to Engram persistent memory via MCP tools.\n` +
        `After compaction, call mem_context to recover previous session context before continuing work.`
      )
      // REMOVED: forced mem_session_summary save after compaction
    },
  }
}
