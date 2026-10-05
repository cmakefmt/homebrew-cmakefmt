# `cmakefmt` Homebrew Tap

[![CI](https://github.com/cmakefmt/homebrew-cmakefmt/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/cmakefmt/homebrew-cmakefmt/actions/workflows/ci.yml)

This tap publishes the official Homebrew formula for [`cmakefmt`](https://github.com/cmakefmt/cmakefmt).

## Install

```bash
brew tap cmakefmt/cmakefmt
brew install cmakefmt
```

Or install directly without a separate tap step:

```bash
brew install cmakefmt/cmakefmt/cmakefmt
```

## Upgrade

```bash
brew update
brew upgrade cmakefmt
```

## What This Repo Contains

- `Formula/cmakefmt.rb`: the official Homebrew formula

The formula is rendered from the main `cmakefmt` repository release workflow and updated per tagged release.

## Bottle Releases

The Release workflow builds and tests bottles for Apple Silicon and Intel
on macOS Sequoia and Tahoe. CI installs Rust independently of Homebrew,
avoiding unavailable Intel dependency bottles and runner dependency conflicts.
Normal source installs still use the formula's Homebrew Rust dependency.

To recover a failed bottle release after a workflow fix, run **Release**
manually from `main`, with the existing tap tag (for example `v2.0.0`).
The workflow builds the formula from that tag, publishes bottles to its
release, and updates the bottle block on `main` only if the formula still
points to that version. It does not create or move tags.

## Troubleshooting

If you previously installed from another tap, check which formula you are using:

```bash
brew info cmakefmt
```

If needed, untap an old source and retap this one:

```bash
brew untap <old-owner>/<old-tap>
brew tap cmakefmt/cmakefmt
brew install cmakefmt
```
