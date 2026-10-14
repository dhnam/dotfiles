# Dotfiles

My own dotfiles for Windows (PowerShell 7 / cmd + clink) and Linux (zsh + oh-my-zsh), with starship and nvim (w/ plugins).

Managed with `chezmoi`. CLI tools are installed with [`mise`](https://mise.jdx.dev) wherever possible (`~/.config/mise/config.toml`); only things mise can't install go through winget / apt.

Note that some keybinds (telescope for example) is quite arbitary.

Is subject to change.

# Setup

## Windows

Prerequirements: winget, and then

```powershell
winget install Git.Git Microsoft.PowerShell twpayne.chezmoi
```

Open a new **PowerShell 7** (`pwsh`) terminal and run

```powershell
chezmoi init --apply dhnam
```

The bootstrap script installs mise, clink, rustup and coreutils via winget, then everything else via mise. It asks for admin (UAC) once, to configure coreutils.

## Linux

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dhnam
```

The bootstrap script assumes `apt` (Debian/Ubuntu). On other distros install `git curl zsh unzip` and a C compiler first.

## After that

Open nvim and download some LSP in need using `:Mason`.

# About the PowerShell profile

`$PROFILE` itself is **not** managed. PowerToys (CommandNotFound) and Microsoft coreutils write their own blocks into it, so managing the whole file means fighting them on every apply. Instead:

- The shared profile lives in `~/.config/powershell/profile.ps1` (managed).
- `run_after_pwsh-profile` makes sure `$PROFILE` has one line that loads it.
- `ls` / `find` / `grep` are replaced with `eza` / `fd` / `rg`. Rather than editing the coreutils block by hand, the bootstrap sets coreutils' own `DisabledUtilities` registry value and regenerates the block, so the setting survives coreutils updates.

# About .zshrc

It's the original file I use, so it contains some of path specific to my env.

Edit them as you need.

# Font

Every Nerd-patched font (/w Nerd Font 3.0+) works, but I used D2CodingNerdFontMono-Regular.

Font can be found [here](https://github.com/dhnam/d2coding-nerd-font). (Not official, but used patcher.)

Note that [Official D2Coding nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/D2Coding) is ligature vertion, so it might broke `<Key>=test` into `<Key≥test`. Use at own risk.

# Preview

![스크린샷 2024-03-19 221253](https://github.com/dhnam/dotfiles/assets/8546820/ee12758a-c104-4f21-a325-53da62cc9be2)


![스크린샷 2024-03-19 222847](https://github.com/dhnam/dotfiles/assets/8546820/108486dc-58a9-4bdb-9385-fc064ad7f12b)
