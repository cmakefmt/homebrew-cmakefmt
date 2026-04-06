# cmakefmt Homebrew Tap

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
