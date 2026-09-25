# WezTerm, Neovim, and Herdr Tutorial

This tutorial explains how to use the terminal environment installed by this
repository. It assumes that you are new to terminal multiplexers and modal
editors.

> The tool is named **Herdr**, not Herder. The shell alias `h` starts it.

This tutorial assumes the repository has remained in the same location where
`./install.sh --apply` was run. The active configuration consists of Stow links
back into that clone. Moving, renaming, or deleting the repository afterward
breaks those links; choose a permanent location before applying the setup.

## 1. The mental model

The three tools have different jobs:

```text
WezTerm window
└── Herdr workspace
    ├── pane: Claude Code or Codex
    ├── pane: Neovim
    └── pane: tests, server, or ordinary shell
```

- **WezTerm** is the macOS terminal window. It renders text, accepts keyboard
  input, provides tabs, and shows the top system-status bar.
- **Herdr** organizes persistent workspaces, tabs, and panes inside the
  terminal. It is especially useful when coding agents run for a long time.
- **Neovim** edits files and reviews changes made by you or an agent.

This setup does not enable WezTerm's multiplexer. Use Herdr for agent-heavy
work, or tmux for general and remote work, instead of nesting all three.

## 2. Start in WezTerm

Open **WezTerm** from Spotlight or the Applications folder. A plain zsh shell
starts automatically.

The top bar contains WezTerm tabs on the left and battery and clock information
on the right:

```text
[1. zsh]                                      BAT+ 72% | Tue Sep 15  14:30
```

- `BAT+` means the battery is charging; `BAT` means it is not charging.
- The display refreshes every ten seconds.

### Useful WezTerm shortcuts on macOS

| Action | Shortcut |
| --- | --- |
| New WezTerm tab | `Command-t` |
| Close current tab | `Command-w` |
| Previous or next tab | `Command-Shift-[` / `Command-Shift-]` |
| Select tab 1–9 | `Command-1` … `Command-9` |
| New WezTerm window | `Command-n` |
| Previous or next window | `Command-\`` / `Command-Shift-\`` |
| Select window 1–9 | `Command-Option-1` … `Command-Option-9` |
| Move active pane to a new window | `Command-Shift-m` |
| Scroll one page | `Command-Up` / `Command-Down` |
| Scroll three lines | `Command-Shift-Up` / `Command-Shift-Down` |
| Copy / paste | `Command-c` / `Command-v` |
| Search terminal output | `Command-f` |
| Increase / decrease font | `Command-+` / `Command--` |
| Reset font size | `Command-0` |
| Reload WezTerm configuration | `Command-r` |

The window title shows its current number, such as `[1]` or `[2]`. Window
numbers match the `Command-Option-1` through `Command-Option-9` shortcuts. A
WezTerm tab is a tab inside one window; `Command-Shift-m` takes the active
Herdr or shell pane out into a separate window without requiring an interactive
shell command.

Use WezTerm tabs for separate top-level activities. Use Herdr's tabs and panes
for the related processes within one project.

### Switch between Gruvbox day and night

The theme command is a **script in this repository**, not a globally installed
CLI or a `mat` command. Run it from the clone, or use its absolute path from
another directory:

```bash
cd /path/to/myagenterminal
./scripts/theme.sh day      # light Gruvbox Soft
./scripts/theme.sh night    # dark Gruvbox Soft
./scripts/theme.sh status   # saved selection
```

Night is the default if no selection file exists. The choice lives outside Git
in `~/.config/myagenterminal/theme`. WezTerm reloads its configuration, and
**new** Neovim sessions use the selected mode with soft contrast; restart an
existing Neovim session to update it. Herdr detects the appearance of its host
terminal and selects Gruvbox or Gruvbox Light. In a terminal other than
WezTerm, Herdr's appearance may therefore differ from the saved choice; its UI
accent colors are not exactly the Soft palette either. `status` reports the
**saved choice**, not the effective appearance of every open window.

## 3. Shell conveniences

The shell defines a few short commands:

| Command | Meaning |
| --- | --- |
| `h` | Start or attach to Herdr |
| `v` | Start Neovim |
| `t` | Start or attach to tmux |
| `ll` | Detailed directory listing with Git information |
| `tree` | Show a directory tree |

`ls`, `ll`, and `tree` emit terminal hyperlinks for displayed paths. Hold
`Command` and click a URL to open it in the browser, or click a `file://` path
to open the local file with its macOS default application. This remains
available when Codex, Neovim, or another pane application is using mouse
reporting because the configured Command modifier is handled by WezTerm.

Other interactive features include:

- autosuggestions based on command history;
- syntax coloring that warns about invalid commands before execution;
- extra command completions;
- Atuin history search;
- fzf fuzzy selection;
- zoxide directory navigation;
- the Starship prompt.

When a faint autosuggestion appears, press the right-arrow key to accept it.
Use `Ctrl-r` to search command history. After zoxide learns your directories,
`z project-name` can replace a long `cd` command.

### Reading the Starship prompt

Starship places the current directory, Git context, and active language runtimes
on one line. For example:

```text
ridge on git:feat/131-iam-tag-based-model [$✘!?] via 🐍 v3.9.6 via  v24.21.0
```

| Segment | Meaning |
| --- | --- |
| `ridge` | Current directory |
| `on git:feat/131-iam-tag-based-model` | Current Git branch |
| `[$✘!?]` | Pending Git state: stashed changes (`$`), deleted files (`✘`), modified files (`!`), and untracked files (`?`) |
| `via 🐍 v3.9.6` | Active Python version |
| `via  v24.21.0` | Active Node.js version |

The configured prompt order is `directory`, `git_branch`, `git_status`,
`python`, `nodejs`, `rust`, and command duration. A segment appears only when
its context applies; for example, Git status is absent in a clean repository.

### Intentional tools in this setup

These tools are installed by the repository because they support the workflow;
they are not random extras. `./install.sh --apply --packages` installs the
Homebrew entries in `Brewfile`. Claude Code and Codex are the exception: they
are installed separately with `./scripts/agents.sh` because their publishers
provide native installers.

| Tool | What it is for | Start here |
| --- | --- | --- |
| Atuin | Search and reuse shell history | `↑` or `Ctrl-r`; type a query, `Enter` edits the selected command, `Esc` exits |
| fzf | Fuzzy selection used by shell integrations | `Ctrl-t` files, `Alt-c` directories, or use it through picker commands |
| zoxide | Jump to frequently used directories | `z project-name` |
| Starship | Prompt showing Git and runtime context | It starts automatically with zsh |
| zsh plugins | Suggestions, syntax highlighting, and completions | Type normally; accept a suggestion with `Right Arrow` |
| bat | Read files with syntax highlighting | `cat README.md` |
| eza | Modern directory listings and trees | `ls`, `ll`, `tree`; `⌘`-click printed paths |
| ripgrep / fd | Search text / find files quickly | `rg "pattern" .` / `fd filename` |
| jq | Inspect and transform JSON | `jq '.items[]' data.json` |
| delta | Readable Git diffs | `git diff` |
| mise | Manage Node 24 and pnpm 10.28.0 | `mise current`, `mise install` |
| uv | Manage Python project environments | `uv sync` or `uv run ...` inside a Python project |
| GitHub CLI | Work with GitHub from the terminal | `gh auth status`, `gh pr list` |

Atuin's Up-arrow screen is intentional: it replaces the usual single-command
history step with a searchable history list. Use `↑`/`↓` to select a result,
`Enter` or `Tab` to edit it at the prompt, `Ctrl-o` to inspect it, and `Esc` to
leave without selecting anything. The command is not executed until you submit
it from the normal shell prompt.

## 4. Learn Neovim's modes first

Start Neovim in a project:

```bash
cd /path/to/project
v .
```

Neovim is a modal editor. A key performs different actions depending on the
current mode.

| Mode | Purpose | Enter it | Leave it |
| --- | --- | --- | --- |
| Normal | Navigate and edit with key commands | Neovim starts here | — |
| Insert | Type text | `i`, `a`, or `o` | `Esc` |
| Visual | Select text | `v` or `V` | `Esc` |
| Command-line | Save, quit, and run editor commands | `:` | `Enter` or `Esc` |

If you are unsure which mode you are in, press `Esc`. This returns you to Normal
mode in most situations.

### Your first edit

1. Press `Space Space` to open the smart file picker.
2. Type part of a filename.
3. Use the arrow keys to select it and press `Enter`.
4. Move with `h`, `j`, `k`, and `l`, or use the arrow keys initially.
5. Press `i`, type a change, and press `Esc`.
6. Press `Space w` to save.
7. Type `:q` and press `Enter` to quit.

Common exit commands:

| Command | Meaning |
| --- | --- |
| `:w` | Save |
| `:q` | Quit if there are no unsaved changes |
| `:wq` | Save and quit |
| `:q!` | Discard unsaved edits and quit |

### Basic Normal-mode movement and editing

| Action | Key |
| --- | --- |
| Move left/down/up/right | `h` / `j` / `k` / `l` |
| Next / previous word | `w` / `b` |
| Start / end of line | `0` / `$` |
| Start / end of file | `gg` / `G` |
| Half-page up / down | `Ctrl-u` / `Ctrl-d` |
| Undo / redo | `u` / `Ctrl-r` |
| Delete character under cursor | `x` |
| Delete current line | `dd` |
| Copy current line | `yy` |
| Paste after cursor | `p` |
| Search in file | `/text`, then `Enter` |
| Next / previous match | `n` / `N` |

The system clipboard is enabled. Text copied in Neovim can be pasted into other
macOS applications, and vice versa.

### Why `q` and `:q` do different things

Normal mode is Neovim's default **command-key** state: pressing `j` moves the
cursor instead of typing the letter `j` into the file. Press `i` to enter
Insert mode when you want to type, then `Esc` to return. From Normal mode,
press `:` to open the command line at the bottom, type `q`, and press `Enter`
to quit the current window (or Neovim if it is the last window). We write
this whole sequence as `:q`: the `q` is text entered on the command line,
not a Normal-mode key action.

By contrast, pressing `q` directly in a regular file's Normal mode starts a
**macro recording** command and waits for a register name such as `a`. The
pending `q` may appear in the bottom status area, but it has not opened the
command line. Press `Esc` to cancel if that was accidental. While recording,
pressing `q` again stops the recording. In special plugin screens the same key
may have another meaning: in Neogit's status screen, `q` closes Neogit.

A macro records a sequence of Neovim key actions so you can replay it. Try a
cursor-only example in a file with at least three lines; it makes no edits:

1. Press `gg` to move to the first line.
2. Press `q`, then `a` to start recording into register `a`.
3. Press `j` to move down one line, then `q` to stop recording.
4. Press `@a` to replay the macro: the cursor moves down one more line.

An editing macro can change text on every replay, so check what you recorded
before repeating it many times. Herdr's `Ctrl-b`, then `[` copy mode is a
different feature: it navigates and copies retained terminal output without
editing the file or recording Neovim keys. Its `q` leaves copy mode.

## 5. Use this Neovim configuration

In the tables below, `Space` is the **leader key**. For example, `Space g g`
means press Space, release it, then press `g` twice.

### Find code

| Action | Shortcut |
| --- | --- |
| Smart file picker | `Space Space` |
| Search text across the project | `Space /` |
| Browse Git branches | `Space g b` |
| Browse Git history | `Space g l` |

The picker supports fuzzy search. Type only distinctive parts of a filename or
phrase, select a result, and press `Enter`. Press `Esc` to close it.

### Browse with Oil; search quickly with Snacks

Oil shows the current file's parent directory as an editable Neovim buffer.
Open it with `Space e` or `:Oil`, press `Enter` to open a file or directory,
and press `-` to move to the parent. `g?` shows Oil's help, and hidden files
are visible. Renaming a line or adding or deleting an entry can change the
filesystem when you save with `:w`, so review those edits first.

Snacks is a separate collection of pickers and UI helpers. `Space Space`
finds files, `Space /` searches project text, and `Space g b` / `Space g l`
browse Git branches and history. This setup also enables its input and
notification UI, large-file handling, and quick file opening. Use Oil to
navigate and manage a directory; use a Snacks picker when you know a file name
or text fragment and want to find it quickly.

### Work with editor splits

Create splits with `:vsplit` or `:split`, then move between them with:

| Direction | Shortcut |
| --- | --- |
| Left | `Ctrl-h` |
| Down | `Ctrl-j` |
| Up | `Ctrl-k` |
| Right | `Ctrl-l` |

These are Neovim splits inside one terminal pane. They are different from
Herdr panes.

### Review Git changes with Gitsigns

Changed lines have signs in the left column. The current line also shows its
Git blame after a short delay.

| Action | Shortcut |
| --- | --- |
| Next / previous changed hunk | `]h` / `[h` |
| Preview the current hunk | `Space h p` |
| Stage the current hunk | `Space h s` |
| Reset the current hunk | `Space h r` |
| Toggle current-line blame | `Space h b` |

Be careful with `Space h r`: it discards the current uncommitted hunk.

### Review the whole repository with Neogit

Press `Space g g` to open Neogit. It provides a repository-wide Git view for
reviewing files, diffs, staging, and commits. Press `?` inside Neogit to see its
context-sensitive controls; use those displayed controls instead of trying to
memorize everything immediately.

For a first-principles explanation of the status screen, sections, hunks, and
`@@` diff headers, read the [Korean Neogit guide](neogit-guide.ko.md).

Which-key also shows available leader-key actions when you pause after pressing
Space.

## 6. Start a Herdr workspace

Start with a real Git project:

```bash
cd /path/to/project
h
```

Running `h` is the same as running `herdr`. It launches or attaches to the
default persistent Herdr session and creates or opens a workspace.

Learn Herdr's hierarchy in this order:

```text
session
└── workspace: one project or task
    └── tab: one layout, such as "development"
        └── pane: one shell, editor, agent, test process, or server
```

- A **session** is the background Herdr server. Most people need only the
  default session.
- A **workspace** normally represents one repository or task.
- A **tab** groups a pane layout, such as `agents`, `tests`, or `server`.
- A **pane** contains one real terminal process.

Start with the mouse: click a pane or tab to focus it, drag pane borders to
resize, and right-click to open contextual menus.

## 7. Understand the Herdr prefix

Herdr commands use `Ctrl-b` as a prefix. This is a sequence, not one large
keyboard chord.

For `Ctrl-b`, then `v`:

1. Hold Ctrl and press `b`.
2. Release both keys.
3. Press `v`.

The first step tells Herdr that the next key is a Herdr command instead of input
for the focused shell or editor.

Press `Ctrl-b`, then `?` at any time to show the active keybindings.

### Read long Codex output in Neovim (no mouse)

You can open the focused Codex pane's Herdr scrollback directly in Neovim. You
do not need to create another pane or enter copy mode first:

1. Focus the Codex pane. If needed, press `Ctrl-b`, then `h/j/k/l` to reach it.
2. Press `Ctrl-b`, release both keys, then press `e`.
3. Herdr opens that pane's scrollback in `$EDITOR`. This setup sets
   `EDITOR=nvim`, so Neovim opens automatically.
4. Press `Esc` for Normal mode. Use `gg` / `G` for the beginning / end,
   `Ctrl-u` / `Ctrl-d` for half-page moves, or `/keyword`, `Enter`, then `n` / `N`
   to search. Use `j` / `k` for one-line adjustments.
5. Type `:q` and press `Enter` to close the editor and return to Herdr.

This opens **Herdr's retained pane text**, not necessarily the whole Codex
conversation. If an older answer is absent because the full-screen app keeps
its own history, ask Codex to save that answer as a Markdown file and open the
file with `v path/to/file.md` in a shell pane.

### Essential Herdr keys

| Action | Sequence |
| --- | --- |
| Show help | `Ctrl-b`, then `?` |
| Split with a new pane on the right | `Ctrl-b`, then `v` |
| Split with a new pane below | `Ctrl-b`, then `-` |
| Focus left/down/up/right pane | `Ctrl-b`, then `h/j/k/l` |
| Cycle to next pane | `Ctrl-b`, then `Tab` |
| Close pane | `Ctrl-b`, then `x` |
| Zoom/unzoom pane | `Ctrl-b`, then `z` |
| Enter resize mode | `Ctrl-b`, then `r` |
| Browse pane scrollback in copy mode | `Ctrl-b`, then `[` |
| Open pane scrollback in `$EDITOR` | `Ctrl-b`, then `e` |
| Toggle sidebar | `Ctrl-b`, then `b` |
| Detach from Herdr | `Ctrl-b`, then `q` |

### Tabs and workspaces

| Action | Sequence |
| --- | --- |
| New tab | `Ctrl-b`, then `c` |
| Previous / next tab | `Ctrl-b`, then `p/n` |
| Select tab 1–9 | `Ctrl-b`, then `1` … `9` |
| Rename tab | `Ctrl-b`, then `Shift-t` |
| Close tab | `Ctrl-b`, then `Shift-x` |
| Open workspace picker | `Ctrl-b`, then `w` |
| Create workspace | `Ctrl-b`, then `Shift-n` |
| Rename workspace | `Ctrl-b`, then `Shift-w` |
| Close workspace | `Ctrl-b`, then `Shift-d` |
| Create a Git-worktree workspace | `Ctrl-b`, then `Shift-g` |

Uppercase actions mean holding Shift for the action key after releasing the
prefix.

### Browse scrollback without a mouse or Page Up/Down keys

Herdr owns the scrollback for its panes while its full-screen interface is
active. A WezTerm `ScrollByPage` shortcut therefore does not navigate Herdr's
pane history. For a quick look, enter Herdr copy mode instead:

```text
Ctrl-b, then [
```

Use these keys while copy mode is active:

| Action | Key |
| --- | --- |
| Move half a page up / down | `Ctrl-u` / `Ctrl-d` |
| Move one line up / down | `k` / `j` |
| Move to the previous / next paragraph | `{` / `}` |
| Search forward / backward | `/` / `?` |
| Repeat the search forward / backward | `n` / `N` |
| Leave copy mode | `q` or `Esc` |

The copy-mode cursor starts at the bottom of the current output. After a large
`Ctrl-u` or `Ctrl-d` movement, `k` and `j` adjust that cursor one line at a
time. For searching or precise positioning, leave copy mode and use the
**Codex-to-Neovim steps above** (`Ctrl-b`, then `e`).

Closing a workspace with `Ctrl-b`, then `Shift-d` closes its Herdr panes after
confirmation. It does not delete the project directory or an associated Git
branch or worktree.

## 8. A practical agent workflow

Open a project and start Herdr:

```bash
cd ~/Documents/Projects/example-project
h
```

Use the first pane for an agent:

```bash
claude
```

or:

```bash
codex
```

Then build this layout:

1. Press `Ctrl-b`, then `v` to create a pane on the right.
2. In the new pane, run `v .` to open Neovim.
3. Press `Ctrl-b`, then `-` to create a pane below.
4. In the bottom pane, run the project's tests or development server.

The result is:

```text
┌──────────────────────┬──────────────────────┐
│ Claude Code / Codex  │ Neovim               │
│                      │ review and edit       │
├──────────────────────┴──────────────────────┤
│ tests, server, logs, or shell               │
└─────────────────────────────────────────────┘
```

When the agent changes files:

1. Focus Neovim with `Ctrl-b`, then `l` or by clicking it.
2. Use `]h` and `[h` to visit changed hunks.
3. Use `Space h p` to inspect a hunk.
4. Use `Space g g` for the repository-wide review.
5. Run relevant tests in the bottom pane.
6. Return to the agent pane and give feedback or the next task.

## 9. Detach, reattach, and stop

Detach without stopping the panes:

```text
Ctrl-b, then q
```

You can also close the WezTerm window. The Herdr background server and its pane
processes continue running.

Later, open WezTerm and reattach:

```bash
h
```

To inspect Herdr outside its interface:

```bash
herdr status
herdr workspace list
herdr session list
```

To actually stop the default Herdr server and its running environment:

```bash
herdr server stop
```

Do not use `server stop` merely to leave the interface; detach instead.

## 10. Agent completion notifications

Herdr is the agent-aware notification source, while WezTerm delivers the macOS
notification. The configured flow is:

```text
Claude Code or Codex changes state
        ↓
Herdr recognizes done or needs-attention
        ↓
Herdr emits a terminal notification
        ↓
WezTerm asks macOS to display it
```

Notifications are forwarded even while the same WezTerm window is focused so
agent completion and attention events are not silently discarded. Herdr sound
also remains enabled for agent changes in background workspaces.

WezTerm can initially request provisional macOS notification authorization.
macOS does not show a permission dialog for provisional authorization and may
place the first notification quietly in Notification Center. Test the complete
route, then look in Notification Center if no banner appears:

```bash
herdr notification show "myagenterminal" --body "Notifications are working" --sound done
```

The repository enables notifications even while WezTerm is focused with:

```lua
config.notification_handling = "AlwaysShow"
```

Reload WezTerm with `Command-r` after changing this setting manually.

This path is more precise than reacting to every terminal bell: Herdr knows
which supported agent changed state, whereas WezTerm alone only knows that a
program emitted a notification or bell sequence.

## 11. Optional agent integrations

Herdr can detect supported agents from their terminal output. Optional native
integrations can provide richer lifecycle state or session restoration.

Check their current status:

```bash
herdr integration status
```

Install only the integrations you want:

```bash
herdr integration install claude
herdr integration install codex
```

These integrations are separate from `AGENTS.md`, but they do write hook files
inside the agents' configuration directories. Treat them as an explicit,
optional setup step rather than part of the automatic myagenterminal installation.

## 12. Troubleshooting

### A Herdr shortcut does nothing

Press `Ctrl-b`, release it, and only then press the action key. Use
`Ctrl-b`, then `?` to verify the current bindings. The macOS desktop or outer
terminal can intercept some direct key combinations, but the configured prefix
sequences avoid most conflicts.

### You accidentally opened Herdr inside Herdr

Nested Herdr sessions are disabled. If `$HERDR_ENV` is `1`, you are already in a
Herdr pane:

```bash
echo $HERDR_ENV
```

Use the existing workspace rather than running `h` again.

### An agent is not detected

Run:

```bash
herdr agent list
herdr integration status
```

Herdr logs are under `~/.config/herdr/`. Because that directory is linked to
the myagenterminal repository, the corresponding `*.log` files and named-session
runtime directory are explicitly ignored by Git; only `config.toml` should be
tracked.

### Agent completion notifications do not appear

Confirm that WezTerm notifications are allowed in macOS System Settings. Reload
the WezTerm configuration with `Command-r`, reload Herdr with
`herdr server reload-config`, and run the notification test from section 10.
The configured `AlwaysShow` mode also forwards notifications while the WezTerm
window is focused. On first use, provisional authorization may place the alert
quietly in Notification Center instead of showing a banner.

### Neovim seems stuck

Press `Esc`, then decide whether to save:

```text
:wq    save and quit
:q!    discard changes and quit
```

### The WezTerm status bar does not update

Press `Command-r` to reload the configuration. If it still does not appear,
restart WezTerm and validate the configuration with:

```bash
wezterm --config-file ~/.config/wezterm/wezterm.lua ls-fonts >/dev/null
```

If a URL or local file does not open, confirm that the path was printed by
`ll` or `tree`, hold `Command` while clicking, and reload WezTerm with
`Command-r`. For a `file://` path, macOS decides which default application
opens the file.

## 13. A small practice exercise

Use a disposable Git repository:

```bash
mkdir -p /tmp/myagenterminal-practice
cd /tmp/myagenterminal-practice
git init
printf '# Practice\n' > README.md
h
```

Then:

1. Open Neovim with `v .`.
2. Find `README.md` with `Space Space`.
3. Insert a new line and save it with `Space w`.
4. Preview the changed hunk with `Space h p`.
5. Open Neogit with `Space g g`.
6. Create a Herdr split with `Ctrl-b`, then `v`.
7. Run `git diff` in the new pane.
8. Detach with `Ctrl-b`, then `q`.
9. Reattach with `h` and confirm that the panes survived.

Once this sequence feels comfortable, use the same layout in a real project.

## Official references

- WezTerm: <https://wezterm.org/config/files.html>
- Neovim user manual: <https://neovim.io/doc/user/>
- Neovim macro recording and replay: <https://neovim.io/doc/user/usr_10/>
- Oil file browser: <https://github.com/stevearc/oil.nvim>
- Snacks pickers and UI helpers: <https://github.com/folke/snacks.nvim>
- Herdr concepts: <https://herdr.dev/docs/concepts/>
- Herdr keyboard guide: <https://herdr.dev/docs/keyboard/>
- Herdr configuration: <https://herdr.dev/docs/configuration/>
