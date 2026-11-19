# Global agent instructions

These apply to every project. Project-level AGENTS.md / CLAUDE.md files take precedence.

## Git

- If the repo has a `no-mistakes` remote, push with `git push no-mistakes` instead of `origin`.
- Never commit `.no-mistakes/` validation evidence. It is ignored globally; if a validation pipeline stages evidence into a branch, drop it before merging.
- Never commit secrets (`.env`, tokens, API keys).

## Maintaining this file

Keep this file for knowledge useful to almost every agent session, in any project.
Do not repeat what a codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
