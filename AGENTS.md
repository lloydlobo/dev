# AGENTS.md

Personal dotfiles / dev-env repo (ThePrimeagen/dev model). Not a software project — no build, test, lint, typecheck, or CI.

## Read state cautiously

Working tree may diverge from `HEAD`. Currently modified: `env/.config/tmux/tmux.conf`, `runs/libs.sh`, `env/.local/scripts/keep`. For committed truth, use `git show HEAD:<path>`.

## Communication

Caveman default voice for chat. Code, commits, file contents stay normal.

Caveat: `.agents/skills/` is **session-local, not git-tracked**. Skills auto-load at opencode session start but are not versioned.

## Tracked layout

```
.envrc_example                          capture-state-before-pop-upgrade.sh
.gitignore                              dev-env.sh
env/.config/{i3,i3status,tmux}/*        env/.local/scripts/*  (24 files)
env/.{tmux-sessionizer.sh,xprofile,
       zsh_profile,zshrc,zshrc_ohmyzsh}
run.sh                                  todo.md
runs/{browsers,dev,discord,docker,
      dotnet,go,ide,keyboard,lazygit,
      libs,neovim,obs,zsh}.sh
```

- `env/.config/*` → `$XDG_CONFIG_HOME/` (defaults `~/.config`)
- `env/.local/*` → `~/.local/`
- Top-level hidden files in `env/` → matching `~/` files
- `capture-state-before-pop-upgrade.sh` — pop!_OS upgrade safety script

## Entry commands

Both require `DEV_ENV` exported (otherwise script exits 1):

```bash
DEV_ENV="$PWD" ./dev-env.sh --dry   # preview deploy of env/ to $HOME
DEV_ENV="$PWD" ./dev-env.sh         # deploy
DEV_ENV="$PWD" ./run.sh --dry       # preview all runs/*.sh
DEV_ENV="$PWD" ./run.sh libs --dry  # filter by substring
```

`run.sh` iterates every executable in `runs/` whose path does not contain the filter substring. No filter = run all. `runs/*.sh` call `sudo apt` and `curl | sh` — never run without user confirmation; always `--dry` first.

## Operational notes

- `dev-env.sh` prefers `trash` over `rm`; install `trash-cli` so deploy does not nuke dotfiles.
- `runs/dev.sh` sets `init.defaultBranch = master` and git identity `Lloyd Lobo <lloydlobo4@gmail.com>` — match these when creating commits.
- `runs/libs.sh` heavy global installer (~50 packages: apt + brew + cargo + npm + uv + curl-pipe-sh + AI CLI suite `{opencode,claude,codex,antigravity,aider,ollama,llm-checker}` + caveman plugin). Do not re-run unless asked.
- `skills-lock.json` tracks installed caveman skills from `JuliusBrussee/caveman` — auto-installed by `runs/libs.sh` via `npx -y github:JuliusBrussee/caveman`.
- Working-tree `env/.local/scripts/keep` has duplicate `trim_entry_prefix` function (defined at line ~148 and again at ~221) — committed version has only one definition.

## Things an agent is likely to get wrong

- Treating as project and running `npm test` / `cargo test` / looking for `src/`.
- Running `runs/*.sh` unguarded — network + `sudo`.
- Adding files at repo root when content belongs in `env/` or `runs/`.
- Reading working-tree files and assuming they match `HEAD` (3 files currently modified).
- If task needs lint/format, ask user which tool before adding config (none wired up).
