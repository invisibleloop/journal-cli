# Journal CLI

A simple command-line tool for keeping a daily journal with optional weather updates and dad jokes. Entries are automatically created every day at 00:01 AM.

## Features
- Create daily journal entries
- Automatically fetch weather updates (optional)
- Automatically fetch a dad joke (optional)
- Auto-runs every day at 00:01 AM
- Built-in update system with version checks

## Installation
Run the following command to install Journal CLI:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/invisibleloop/journal-cli/main/install.sh)
```

This will:
- Download the `journal` script
- Make it executable
- Add it to `~/.local/bin/` (so you can run `journal` anywhere)
- Set up a cron job to create a new journal entry every day at 00:01 AM

### Command Not Found?
If you see `command not found: journal` after installing, your shell might not be recognizing `~/.local/bin/`. Fix this by adding it to your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

To make this change permanent, add it to your shell configuration file:

- **For Zsh users** (default on macOS):
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  ```

- **For Bash users** (default on most Linux distros):
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  ```

## Usage

### Create a Journal
To create a journal, run:
```bash
journal create --path ~/journal -w -j
```

**Options:**
- `--path <directory>`  → Set the journal directory (default: `~/journal`)
- `-w`  → Include weather information
- `-j`  → Include a dad joke

Example:
```bash
journal create --path ~/journal -w -j
```
This will create an entry for today with weather and a dad joke.

### Automated Journal Entries
A cron job is automatically installed to create a journal entry every day at 00:01 AM.

To **change the scheduled time**, run:
```bash
crontab -e
```
Edit the time for the journal entry creation.

## Updating Journal CLI
The script automatically checks for updates.

To manually update:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/invisibleloop/journal-cli/main/install.sh)
```
This will download the latest version and replace the existing one.

Or use the built-in update command:
```bash
journal update
```

## Journal Entry Format
Each entry is saved as `YYYY/MM/DD.md` in the specified directory.

Example:
```
# Journal: 19/03/2025

**Weather:** Partly Cloudy +10°C

---

## To Do:
- [ ] example

---
**Dad Joke of the Day:**
Why did the scarecrow win an award? Because he was outstanding in his field!
```

## Uninstall
To remove Journal CLI and its cron job:
```bash
rm -f ~/.local/bin/journal
crontab -l | grep -v 'journal create' | crontab -
```

## License
MIT License

## Contributing
Pull requests are welcome! Feel free to fork the repo and submit improvements.

