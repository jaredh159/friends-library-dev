# Fell

Group manipulation of friend repositories.

> Note: all these examples assume you have a bash alias for the `fell` command, something
> like:

```bash
alias fell='node /path/to/fell/dist/app.js "$@"'
```

## Commands

```SHELL
$ fell branch
$ fell status
$ fell checkout -b feature-x
$ fell commit -m "my message"
$ fell push feature-x --open-pr
$ fell delete feature-x
$ fell sync # pull --rebase
$ fell clone
$ fell workflows
```

_Exclude_ repos by passing strings, if these strings appear _anywhere in repo path_, that
repo will be excluded:

```SHELL
$ fell branch --exclude wheeler
$ fell branch --exclude wheeler --exclude fox
```

Or, you can _scope_ most command to repos on a specific branch, using the `--scope` flag:

```SHELL
$ fell commit -m "feature x is rad" --scope feature-x
```

### `branch`

Reports the current HEAD branch for all repos.

```SHELL
$ fell branch
```

### `status [--scope]`

Reports the current status for all repos.

```SHELL
$ fell status
$ fell status --scope master # only report repos on branch = `master`
```

### `checkout [-b] <branchname> [--exclude] [--scope]`

Checkout a branch for all selected repos. Only repos with a clean status will checkout to
requested branch. If `-b` is passed, a new branch will be created, same as standard
`git checkout -b <branchname>`. Like most other commands, the scope of this command can be
restricted by passing a `--scope` option, so that the command will only operate on repos
that started on that branch.

```SHELL
$ fell checkout -b feature-x
$ fell checkout -b feature-x --scope master # only checkout if repo WAS `master`
```

### `commit --message "my commit message" [--exclude] [--scope]`

Stage everything `git add .` and commit to all repos.

```SHELL
$ fell commit --message "my message" --scope feature-x
$ fell commit -m "my message" # -m shorthand for message
```

### `push <branch> [--open-pr] [--pr-title] [--pr-body] [--delay]`

Push branch from all repos to remote: `origin`. Can also auto-open Pull Requests with the
`--open-pr` option. By default the pull request title will be the most recent commit
message and the pull request body will be empty, unless you pass custom strings using
`--pr-title` and/or `--pr-body`.

**Note:** This command _auto-scopes_ to the `<branch>` you pass.

**Note:** You can pass a `--delay` flag (in seconds) to add seconds between PR creation.
This helps prevent GitHub api abuse sensors.

```SHELL
$ fell push feature-x --open-pr --pr-title "my rad pr!"
$ fell push master # push all repos straight to master
$ fell push feature-x --delay 120 # delay 2 minutes between each push
```

### `delete <branch> [--exclude] [--scope]`

Delete branch from repos. Seems to always behave as if _forced_
(`git branch -D <branch>`).

```SHELL
$ fell delete feature-x  # delete all `feature-x` branch
```

### `sync [--exclude] [--scope]`

Sync local repos with `origin/master`. Similar to `git pull --rebase`. Only operates on
repos with clean statuses. Should only do fast-forward merges.

```SHELL
$ fell sync
$ fell sync --exclude wheeler
$ fell sync --scope feature-x
```

### `workflows [--exclude]`

Update all non-excluded repos with github action workflow files from `workflows/*.yml`.
Allows for mass-updates of github actions for all doc repos. Usually combined with
`fell commit` and `fell push`
