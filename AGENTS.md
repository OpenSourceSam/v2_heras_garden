## Working Agreement (for AI agents)

Goal: keep Git history clean and avoid leaving large piles of uncommitted changes.

### Commits (default behavior)
- Do **not** run `git commit` unless Sam explicitly asks for a commit in chat.
- If there are more than ~10 changed files, or changes span multiple subsystems, **pause and ask** Sam whether to:
  - commit everything,
  - commit only the changes from the current task, or
  - split into multiple commits.
- Prefer **small, focused commits** (one feature/fix per commit) with clear messages.
- Avoid mixing unrelated refactors, formatting-only changes, or deletions into the same commit as gameplay fixes.

### Staging rules
- Use `git add <paths...>` to stage only files relevant to the current task.
- Do not stage large doc deletions or untracked folders unless Sam explicitly confirms.

### End-of-task hygiene
- Before ending a work chunk, run `git status --short`.
- If changes remain, summarize what is uncommitted and ask whether to commit, stash, or leave as-is.

