# claude-peak-indicator

A SwiftBar plugin that shows Claude's peak and off-peak hours in your macOS menu bar.

<!-- TODO: Add screenshot -->

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/bastianibanez/claude-peak-indicator/main/install.sh | bash
```

## What It Shows

- **Orange dot** — Peak hours (standard usage limits)
- **Green dot** — Off-peak (2x usage bonus active)

## Schedule

Peak hours: **Monday–Friday, 8 AM – 2 PM ET**

Outside those hours (evenings, weekends) you get 2x usage.

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/bastianibanez/claude-peak-indicator/main/uninstall.sh | bash
```

## How It Works

The plugin is a bash script that runs every minute (SwiftBar filename convention: `*.1m.sh`). It checks the current time in Eastern Time and displays a colored dot accordingly.

## Requirements

- macOS
- [Homebrew](https://brew.sh) (the installer uses it to install SwiftBar)
- [SwiftBar](https://github.com/swiftbar/SwiftBar) (installed automatically)
