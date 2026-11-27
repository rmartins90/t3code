# Rui's T3 Code fork

A personal build of [T3 Code](https://github.com/pingdotgg/t3code), for my own use. It is unofficial and not distributed. If it ever is, replace the T3 Code name, logos and icons first, as [TRADEMARK.md](../TRADEMARK.md) requires.

## Branches

- `main` mirrors `pingdotgg/t3code`. Never commit to it.
- `rui` holds my changes on top of the newest stable release tag, so its database schema matches the official stable app and switching back stays safe.
- Changes that would help everyone go upstream as PRs from a branch on `upstream/main`, which shrinks what `rui` carries.

## Update

```sh
git switch rui
fork/update.sh   # rebase onto the newest stable tag, push, build release/*.dmg
```

The rebase stops on conflicts: resolve them, run `git rebase --continue`, then run `fork/update.sh` again.

## Install

Quit every T3 Code app, then from Terminal:

```sh
fork/install.sh
```

It clones `~/.t3/userdata` and `~/Library/Application Support/t3code-v2` into `~/.t3/backups/<timestamp>` (APFS clones, kept two at a time), installs `T3 Code (Rui).app` in `/Applications` and opens it. The app uses the same data as the official one.

To restore a backup, quit the app and run:

```sh
rm -rf ~/.t3/userdata && cp -cR ~/.t3/backups/<timestamp>/userdata ~/.t3/userdata
```

## Notes

- The bundle is named `T3 Code (Rui)`, but the runtime name stays `T3 Code Beta`, so the app reads the same Keychain entry as the official one. On first launch, allow its Keychain access.
- Local builds have no update feed: they never update themselves or get replaced by the official app.
- Build requirements: `fnm`, the Node version in `package.json` `engines`, and pnpm through Corepack, which switches to the version in `packageManager`. `npx pnpm` does not work here, because `ignore-scripts=true` in npm leaves pnpm's native binary uninstalled.
- For development, `pnpm dev:desktop` keeps its data in `~/.t3/dev`. Never point it at `~/.t3/userdata`.
