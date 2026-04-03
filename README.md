# claude-peak-indicator

A SwiftBar plugin that shows Claude's peak and off-peak hours in your macOS menu bar.

<!-- TODO: Add screenshot -->

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/bastianibanez/claude-peak-indicator/main/install.sh | bash
```

## What It Shows

- **Orange dot** — Peak hours (session limits drain faster)
- **Green dot** — Off-peak (good time for token-intensive tasks)

## Schedule

Peak hours: **Monday–Friday, 5 AM – 11 AM PT**

During peak hours, your 5-hour session limits are consumed faster than usual. Shifting heavy background jobs to off-peak hours stretches your weekly limits further.

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
