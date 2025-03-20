#!/bin/bash

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_URL="https://raw.githubusercontent.com/invisibleloop/journal-cli/main/journal.sh"
JOURNAL_PATH="$INSTALL_DIR/journal"
CRON_TIME="7:00"

# Function to display usage
usage() {
    echo "Usage: install.sh [-t <time>]"
    echo "  -t <time>    Set the time for the daily journal entry (default: 7:00 AM)"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -t)
            CRON_TIME="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

# Create bin directory if not exists
mkdir -p "$INSTALL_DIR"

# Download journal script
curl -fsSL "$SCRIPT_URL" -o "$JOURNAL_PATH"

# Make it executable
chmod +x "$JOURNAL_PATH"

# Ensure journal is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.zshrc"
fi

# Convert time to cron format
CRON_HOUR=$(echo "$CRON_TIME" | cut -d: -f1)
CRON_MINUTE=$(echo "$CRON_TIME" | cut -d: -f2)

# Set up cron job for daily journal entry
CRON_JOB="$CRON_MINUTE $CRON_HOUR * * * $JOURNAL_PATH create --path ~/journal -w -j"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | sort -u | crontab -

echo "✅ Journal CLI installed successfully!"
echo "Run 'journal create --path ~/journal -w -j' to start."
echo "Daily journal entry will be created at $CRON_TIME."
