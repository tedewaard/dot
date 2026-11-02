# Global agent instructions

## Issue Tracking (beads)

All issue tracking uses **bd (beads)** against a single shared database:

- Location: `$BEADS_DIR` (`~/serepo/issues/.beads`, set in `~/.bashrc`), prefix `iss`
- Use this database from every working directory. `bd` resolves it via `BEADS_DIR`.
- **Never run `bd init`** in another repo or directory. If `bd` reports
  "No active beads workspace found", `BEADS_DIR` is unset — stop and tell the user.
- Run `bd prime` at the start of a session for full workflow context.
- When you create a bead, assign it to the user: pass `--assignee "Trevor Edewaard"`
  to `bd create` (or run `bd update <id> --assignee "Trevor Edewaard"` afterward).
- When you create a bead for work in a git repo, add a `repo:<repo-name>` label
  (e.g. `-l repo:opensearch-ansible`). Get `<repo-name>` from the `origin` remote:
  `basename -s .git "$(git remote get-url origin)"`. If there is no remote, use the
  repo root folder name: `basename "$(git rev-parse --show-toplevel)"`. Use lowercase.
- Add the `repo:` label only when the bead is about that repo's work. Beads not
  tied to a repo (e.g. "look into Pure CSI driver") get no `repo:` label.

**Quick reference:**
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2 --assignee "Trevor Edewaard"` - Create issue
- `bd update <id> --status in_progress` - Claim work
- `bd close <id>` - Complete work
- `bd list -l repo:<repo-name>` - List all work for a repo
- `bd sync` - Pull, resolve, and push beads to the remote
