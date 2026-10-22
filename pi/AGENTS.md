# Global agent instructions

## Issue Tracking (beads)

All issue tracking uses **bd (beads)** against a single shared database:

- Location: `$BEADS_DIR` (`~/serepo/issues/.beads`, set in `~/.bashrc`), prefix `iss`
- Use this database from every working directory. `bd` resolves it via `BEADS_DIR`.
- **Never run `bd init`** in another repo or directory. If `bd` reports
  "No active beads workspace found", `BEADS_DIR` is unset — stop and tell the user.
- Run `bd prime` at the start of a session for full workflow context.

**Quick reference:**
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2` - Create issue
- `bd update <id> --status in_progress` - Claim work
- `bd close <id>` - Complete work
- `bd sync` - Pull, resolve, and push beads to the remote
