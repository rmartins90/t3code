# Working in Rui's fork

This checkout is Rui's personal fork of T3 Code. The rules in the root AGENTS.md apply, with these differences.

## Commands

- Vite+ is not installed globally. Wherever the docs say `vp`, run `fork/vp` from the repository root, with the same arguments: `fork/vp run check:changed`, `fork/vp test run <files>`. It uses the Node version pinned in `package.json`.
- Install dependencies with `fork/vp i`. Project setup runs it in new worktrees.
- Don't run `fnm use` by itself: it changes the Node version of every shell that shares this environment. Use `fork/vp`, or `fnm exec --using=<version>`.

## Branches

- `rui` holds Rui's changes on top of the newest stable release tag. Branch from `rui` and merge back into it. Don't commit to `main`, which mirrors upstream.
- A change meant for upstream goes on a branch from `upstream/main` and is proposed as a PR to `pingdotgg/t3code`. Ask Rui before opening one.

## Building and installing

- `fork/update.sh` rebases `rui` onto the newest stable tag, pushes it and builds `release/*.dmg`. Run it only when Rui asks, since it rewrites the published branch.
- Don't run `fork/install.sh`. It needs every T3 Code app closed, including the one running this session, so Rui runs it from Terminal.
- See [README.md](README.md) for backups and restoring.
