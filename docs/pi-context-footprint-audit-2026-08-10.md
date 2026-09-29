# Pi Context Footprint Audit

**Date:** 2026-08-10
**Status:** Review only; no packages or skills were removed

## Summary

The current Pi installation has:

- 22 package-managed extensions
- 1 local extension (`skill-visualizer`)
- 50 filesystem skills, plus package-provided skills
- Approximately 70 skill descriptions available in the prompt

Pi progressively loads skills: only each skill's name and description are always present. Full `SKILL.md` instructions load on demand. Extension tool schemas and injected instructions generally cost more context than skills.

## Recommended first pass

1. Compact `MEMORY.md`.
2. Trim the 44-model spar configuration.
3. Remove the VTSTech extension bundle, cron, and heartbeat.
4. Remove stale skill backup directories.
5. Disable or archive unused Foundry and workflow skills.
6. Restart Pi and compare context usage.
7. Consider removing session recall and MCP support afterward.

A conservative first pass may save approximately 12,000–18,000 tokens per turn while retaining the tools used most often.

## Strong extension removal candidates

| Package | Evidence | Recommendation |
| --- | --- | --- |
| `git:github.com/VTSTech/pi-coding-agent` | Registers many tools. In the last 30 days, only the hex-edit tools were used, for 8 calls; most of the bundle was unused. | Strong candidate. Removing it drops duplicate memory, diagnostics, security, model-sync, soul, and hex tools. |
| `npm:@e9n/pi-cron` | No cron jobs are configured and the tool had no recent usage. | Remove. |
| `npm:@e9n/pi-heartbeat` | No project or global `HEARTBEAT.md` was found. | Remove. |
| `npm:pi-autoresearch` | Its skills were loaded only twice in 90 days. | Remove unless autonomous experiments are planned. |
| `npm:@ogulcancelik/pi-session-recall` | Four calls in 30 days. | Remove if occasional session recall does not justify two permanent tool schemas. |
| `npm:pi-mcp-adapter` | Twenty calls in 30 days, but its MCP tools have relatively large schemas. | Keep if MCP remains useful; otherwise this is a meaningful reduction. |
| `npm:pi-ollama-cloud` | Three web-tool calls, but it may also support Ollama Cloud models used by spar. | Remove only if Ollama Cloud model access is unnecessary. |

### Proposed removal commands

Disable candidates with `pi config` first. Restart Pi and confirm that nothing important is missing before uninstalling.

```bash
pi remove git:github.com/VTSTech/pi-coding-agent
pi remove npm:@e9n/pi-cron
pi remove npm:@e9n/pi-heartbeat
pi remove npm:pi-autoresearch
```

Do not manually remove packages from `~/.pi/agent/npm/package.json`. Use `pi remove` so Pi updates its managed settings correctly.

## Extensions to retain

Recent 30-day usage supports keeping these packages:

| Extension | Approximate recent usage | Reason to retain |
| --- | ---: | --- |
| `context-mode` | 1,016 calls | Heavily used for large-output processing and context-efficient analysis. |
| `pi-lens` | About 140 calls | Frequently used for diagnostics, navigation, and structural code analysis. |
| `pi-subagents` | 127 calls | Required by delegated review and implementation workflows. |
| `pi-spar` | 68 calls | Actively used, although its model catalogue should be reduced. |
| `@e9n/pi-memory` | 135 calls | Actively used for durable project context. The stored content needs compaction. |
| `@ollama/pi-web-search` | 22 calls | The preferred web-search integration. |
| `@e9n/pi-vault` | 8 calls | Supports the Obsidian project workflow. |
| `@e9n/pi-jobs` | Occasional | Provides useful usage and cost telemetry with modest relative cost. |

## Extensions with little prompt impact

These extensions appear to provide providers, commands, logging, themes, or prompt templates rather than large always-visible tool schemas. Removing them solely to reduce context is unlikely to help much:

- `npm:@e9n/pi-logger`
- `npm:@e9n/pi-openrouter`
- `npm:@e9n/pi-github`
- `npm:@e9n/pi-context`
- `npm:pi-prompt-template-model`
- `git:github.com/paoloanzn/pi-black`
- Local `skill-visualizer`

`pi-context-breadcrumbs` should also remain if path-sensitive `AGENTS.md` guidance is useful.

## Skill cleanup

### Stale backup directories

The following backup directories remain under a discovered skill root:

```text
~/.pi/agent/skills/arity-design.backup.1784929921
~/.pi/agent/skills/nano-banana-images.backup.1784929921
~/.pi/agent/skills/nopcommerce-product-descriptions.backup.1784929921
~/.pi/agent/skills/spar-model-sync.backup.1784929921
~/.pi/agent/skills/universal-learning-system.backup.1784929921
```

Some backup copies are winning skill resolution over their canonical symlinks. Relocate them outside `~/.pi/agent/skills` or delete them after confirming the canonical versions are correct.

This primarily fixes stale precedence. Pi generally deduplicates skills by name, so the direct context saving is modest.

### Duplicate symlinks

Many skills in `~/.pi/agent/skills` are symlinks to skills already discovered under `~/.agents/skills`. Pi deduplicates same-name skills, so these links mostly add filesystem clutter rather than prompt context. They can be cleaned after the backup-precedence issue is resolved.

### Rarely used skills to archive

Good candidates for relocation outside discovered skill roots include:

- `microsoft-foundry` and its nested deployment skills
- `ask-matt`
- `decision-mapping`
- `edit-article`
- `implement`
- `improve-codebase-architecture`
- `prototype`
- `setup-matt-pocock-skills`
- `teach`
- `to-issues`
- `to-prd`
- `triage`
- Unused `writing-*` skills

The Foundry skill group is particularly valuable to remove when inactive because it contributes several unusually long descriptions and was loaded only once in the observed 90-day period.

Arity-specific skills can become project-local instead of global. That reduces context in other repositories, though not while Pi is running inside this infrastructure repository.

### Package skill descriptions

Use `pi config` to disable package-provided skills that duplicate obvious tool functionality while retaining their extensions. Possible examples include the individual `ctx-*` utility skills if their slash-command guidance is unnecessary.

## Larger context reductions

### Persistent memory

The largest avoidable context cost is currently memory, not the skill list.

`MEMORY.md` measurements:

- 29,322 bytes
- Approximately 7,331 tokens
- 20 repeated `Active Projects` headings
- 3 repeated `Arity nopCommerce — Current State` headings

Recent daily logs automatically injected into the prompt add approximately:

- 2026-08-09: 1,585 tokens
- 2026-08-10: 1,479 tokens

The memory extension therefore contributes roughly 10,400 tokens per turn in the current project.

Recommended cleanup:

- Keep one current Arity project snapshot in `MEMORY.md`.
- Remove superseded branch and pull-request snapshots.
- Keep historical detail in daily logs and the Obsidian project dashboard.
- Keep future daily entries concise because today's and yesterday's logs are automatically injected.

This change alone could save approximately 7,000–9,000 tokens per turn.

### Spar model catalogue

`~/.pi/agent/spar/config.json` currently contains:

- 44 model aliases
- 12,229 bytes of configuration

The spar extension includes the configured model catalogue and descriptions in its tool documentation. Recommended options:

1. Keep only 8–12 frequently used model aliases; or
2. Retain the aliases but shorten or remove verbose descriptions.

Likely core candidates based on actual usage include:

- `claude-sonnet-4`
- `gpt-4o`
- `deepseek-v4`
- `deepseek-v32`
- `gemini-2.5-pro`
- `qwen3-coder`
- One Ollama Cloud model
- One free or experimental model

This can preserve spar while saving an estimated 2,000–3,000 prompt tokens.

## Suggested staged process

1. Record the current context measurement using Pi's context command.
2. Disable candidate resources with `pi config`.
3. Compact memory and spar configuration.
4. Restart Pi so tool schemas and skill discovery are rebuilt.
5. Compare the new context measurement.
6. Exercise retained workflows: memory, subagents, lens, context-mode, spar, web search, and Obsidian.
7. Permanently uninstall only the candidates that were not missed.

## Sources reviewed

- Pi package settings: `~/.pi/agent/settings.json`
- Installed package inventory: `pi list`
- Pi documentation:
  - `docs/skills.md`
  - `docs/extensions.md`
  - `docs/packages.md`
- Recent Pi session telemetry and tool usage
- Current filesystem skill roots
- Current project memory files
- Spar model configuration
