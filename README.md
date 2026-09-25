# myagenterminal

A terminal-first, agent-oriented macOS development environment built around
Homebrew, GNU Stow, mise, and a single version-controlled source of truth.

Cloning this repository changes nothing on the machine. The installer is a dry-run
by default and refuses to overwrite existing files or unrelated symlinks.

처음 사용하는 개발자는 먼저 [한국어 개발환경 설계 가이드](docs/design-guide.ko.md)를
읽어 각 도구의 역할, 안전한 적용 순서, 기존 설정과 충돌할 때의 대응 방법을
확인하세요. 실제 사용법은 [WezTerm, Neovim, and Herdr tutorial](docs/tutorial.md)에
설명되어 있습니다. 빠른 단축키는 [한국어 치트시트](docs/cheatsheet.ko.md)를
참고하세요. 상세 튜토리얼 PDF는 [튜토리얼 PDF](output/pdf/tutorial.ko.pdf),
빠른 참고용 인쇄 PDF는 [치트시트 PDF](output/pdf/cheatsheet.ko.pdf)입니다.

## Inspiration

myagenterminal is inspired by [Kun Chen's dotfiles](https://github.com/kunchenguid/dotfiles),
especially its reproducible terminal-first macOS environment, WezTerm and
Neovim workflow, Herdr integration, and shared agent-policy model.

This project adapts those ideas rather than mirroring that repository: it uses
Homebrew, mise, and GNU Stow instead of a Nix-heavy system; keeps Claude Code
and Codex publisher-managed; and leaves global agent-policy installation as a
manual, user-controlled step.

Kun Chen's setup creates a stable `~/.dotfiles` link and uses Nix Home Manager's
`mkOutOfStoreSymlink` for live configuration. myagenterminal keeps the same
single-source-of-truth principle but links each declared package directly with
GNU Stow. We chose Stow because its behavior is visible in a dry-run, it refuses
ordinary-file conflicts, and a beginner can understand or reverse the setup
without first learning Nix, flakes, nix-darwin, and Home Manager.

## Repository location is part of the installation

Choose a permanent clone location before running `./install.sh --apply`. Stow
links the home-directory paths directly to files inside that clone. Do not move,
rename, or delete the repository after applying it; doing so leaves dangling
links and makes the affected applications behave as if their configuration is
missing.

Cloning alone still changes nothing. The location becomes significant only
after `--apply` creates the links. If relocation is unavoidable, preview and
repair the Stow links from the new location before opening a new shell or relying
on the managed tools.

The linked directories contain reproducible configuration, not runtime state.
Machine-generated Herdr session data and plugin locks are ignored by Git so they
cannot be mistaken for portable configuration.

## What is managed

- Terminal and shell: WezTerm, plain zsh, Starship, zoxide, fzf, Atuin,
  autosuggestions, syntax highlighting, and completions
- Workspaces: tmux for general/remote work, Herdr for agent-heavy work
- CLI: ripgrep, fd, bat, eza, jq, delta, GitHub CLI
- Runtimes: mise with Node 24 and pnpm 10.28.0; uv for Python projects
- Review editor: Neovim with Gitsigns, Neogit, Snacks, and which-key
- Agents: publisher-native Claude Code and Codex CLI, plus a global policy template

## Repository layout

```text
.
├── Brewfile                 package inventory
├── install.sh               safe bootstrap entry point
├── AGENTS.md                instructions for this repository
├── agents/AGENTS.md         global policy reference template
├── scripts/
│   ├── bootstrap.sh         dry-run/apply implementation
│   ├── agents.sh            publisher-native agent CLI management
│   ├── check.sh             isolated installer verification
│   └── macos.sh             optional macOS defaults, dry-run by default
├── wezterm/                 Stow packages mirror the home directory
├── zsh/
├── starship/
├── atuin/
├── tmux/
├── herdr/
├── mise/
├── nvim/
└── git/
```

## Preview first

GNU Stow must already be available for the preview:

```bash
brew install stow
./install.sh
```

The command reports prospective links and conflicts but makes no changes. Package
status can also be checked without installing anything:

```bash
./install.sh --packages
```

## Apply explicitly

After choosing a permanent repository location and reviewing the dry-run:

```bash
./install.sh --apply
```

To install missing Brewfile packages without bulk-upgrading existing tools, and
then create links:

```bash
./install.sh --apply --packages
```

The installer deliberately does not use `stow --adopt`. If `~/.zshrc` or another
target already exists, it stops and leaves that file untouched. Compare the files,
move the existing one to a backup location yourself, and run the preview again.

Optional macOS defaults are independent and opt-in:

```bash
./scripts/macos.sh
./scripts/macos.sh --apply
```

## Native agent CLIs

Claude Code and Codex are deliberately not installed by `Brewfile`. Their publishers'
native installers place launchers under `~/.local/bin`, which `.zprofile` adds to PATH.
The tracked manager is read-only by default:

```bash
./scripts/agents.sh status
./scripts/agents.sh install
```

After reviewing the preview, install both CLIs explicitly:

```bash
./scripts/agents.sh install --apply
```

Claude defaults to its stable channel and then uses its native updater. Codex defaults
to its latest release and updates by rerunning OpenAI's standalone installer:

```bash
./scripts/agents.sh update
./scripts/agents.sh update --apply
```

Override these defaults for a single operation with `CLAUDE_CHANNEL` or
`CODEX_RELEASE`. Do not install the same CLI through Homebrew or npm as well; the
manager stops when PATH points to a conflicting installation.

Node and pnpm are declared in mise rather than installed directly by Homebrew.
Projects can override either version with their own mise or package metadata.

Official setup references:

- https://code.claude.com/docs/en/setup
- https://learn.chatgpt.com/docs/codex/cli

## Agent instruction layering

`agents/AGENTS.md` is a version-controlled reference for a global policy. The
installer deliberately does not copy, merge, or link it into either agent's home
directory. Review it and configure each agent manually so an existing personal
policy is never replaced or given conflicting instructions automatically.

Relevant user-owned files include:

```text
~/.codex/AGENTS.md
~/.claude/CLAUDE.md
```

Codex loads the global file first, followed by project-level `AGENTS.md` files from
the repository root toward the working directory. Keep project commands,
architecture, and domain rules in each project's committed `AGENTS.md`; keep
vendor-specific exceptions small and local.

If one of the user-owned files already exists, compare it with
`agents/AGENTS.md` and manually copy only the rules you want. Do not replace the
existing file blindly. Changes to the template are not propagated automatically.

Official Codex reference:
https://developers.openai.com/codex/guides/agents-md/

## Daily use

Use `t` for tmux and `h` for Herdr. They are intentionally peers rather than a
default nested stack. WezTerm's mux domains and workspaces are deliberately not
configured; WezTerm acts only as the terminal frontend. tmux uses `Ctrl-a`; Herdr
keeps its default `Ctrl-b` prefix.

WezTerm keeps its tab bar visible at the top and shows battery charge and the
current date and time on the right. The status refreshes every ten seconds;
`BAT+` means the battery is charging.

Herdr sends agent-completion and attention notifications through WezTerm.
Notifications are forwarded even while WezTerm is focused, and Herdr keeps
sound alerts enabled for agents in background workspaces. WezTerm may request
provisional macOS authorization without displaying a permission dialog, so
check Notification Center after the first test. Test delivery with:

```bash
herdr notification show "myagenterminal" --body "Notifications are working" --sound done
```

In Neovim:

- `<leader><space>` finds files and `<leader>/` searches text.
- `<leader>gg` opens Neogit.
- `]h` / `[h` move between changed hunks.
- `<leader>hp`, `<leader>hs`, and `<leader>hr` preview, stage, and reset a hunk.

## Verify the method

The check runs in an isolated temporary home directory:

```bash
./scripts/check.sh
```

It validates shell syntax, dry-run behavior, first application, idempotency, and
that existing Codex and Claude instruction files remain unchanged, without touching
the real home directory.
