#!/bin/bash

JOURNAL_DIR="$HOME/journal"
INCLUDE_WEATHER=false
INCLUDE_JOKE=false
REPO_URL="https://raw.githubusercontent.com/invisibleloop/journal-cli/main"
VERSION_FILE="$HOME/.journal_version"
VERSION="0.1.0"

# Load the stored version if it exists
if [[ -f "$VERSION_FILE" ]]; then
    VERSION=$(cat "$VERSION_FILE")
fi

# Function to check for updates
check_for_updates() {
    LATEST_VERSION=$(curl -fsSL "$REPO_URL/version.txt")
    if [[ "$LATEST_VERSION" != "$(cat $VERSION_FILE 2>/dev/null || echo "$VERSION")" ]]; then
        echo "🚀 A new version ($LATEST_VERSION) is available! Run 'journal update' to upgrade."
    fi
}

# Function to update the script
update_script() {
    echo "🔄 Updating Journal CLI..."
    curl -fsSL "$REPO_URL/journal.sh" -o "$0"
    chmod +x "$0"

    # Fetch and store the new version
    LATEST_VERSION=$(curl -fsSL "$REPO_URL/version.txt")
    echo "$LATEST_VERSION" > "$VERSION_FILE"

    echo "✅ Journal CLI updated successfully to version $LATEST_VERSION!"
    exit 0
}

# Function to display usage
usage() {
    echo "Usage: journal create --path <directory> [-w] [-j]"
    echo "  create               Create a new journal entry"
    echo "  update               Update Journal CLI to the latest version"
    echo "  --path <directory>   Set the journal directory (default: ~/journal)"
    echo "  -w                   Include weather"
    echo "  -j                   Include a dad joke"
    exit 1
}

# Check if first argument is missing or invalid
if [[ "$1" == "" ]]; then
    usage
fi

# Handle update command
if [[ "$1" == "update" ]]; then
    update_script
fi

# Handle create command
if [[ "$1" != "create" ]]; then
    usage
fi
shift  # Remove 'create' from the argument list

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --path)
            JOURNAL_DIR="$2"
            shift 2
            ;;
        -w)
            INCLUDE_WEATHER=true
            shift
            ;;
        -j)
            INCLUDE_JOKE=true
            shift
            ;;
        *)
            usage
            ;;
    esac
done

# Get today's date details
YEAR=$(date +%Y)
MONTH=$(date +%B)
DAY=$(date +%d)
DATE_FORMATTED=$(date +"%d/%m/%Y")

# Construct paths
MONTH_DIR="$JOURNAL_DIR/$YEAR/$MONTH"
FILE_PATH="$MONTH_DIR/$DAY.md"

# Create directories if they don't exist
mkdir -p "$MONTH_DIR"

# Check if file already exists
if [[ -f "$FILE_PATH" ]]; then
    echo "Journal entry for $DATE_FORMATTED already exists: $FILE_PATH"
    exit 0
fi

# Start journal entry content
ENTRY="# Journal: $DATE_FORMATTED\n\n"

# Fetch weather if requested
if [ "$INCLUDE_WEATHER" = true ]; then
    WEATHER=$(curl -s "wttr.in/?format=%C+%t")
    ENTRY+="**Weather:** $WEATHER\n\n"
fi

ENTRY+="---\n\n## To Do:\n- [ ] write a test\n\n"

ENTRY+="---\n\n## Notes:\n- I did great work today!\n\n"

# Fetch a dad joke if requested
if [ "$INCLUDE_JOKE" = true ]; then
    DAD_JOKE=$(curl -s -H "Accept: text/plain" https://icanhazdadjoke.com/)
    ENTRY+="---\n**Dad Joke of the Day:**\n$DAD_JOKE\n"
fi

# Write content to file
echo -e "$ENTRY" > "$FILE_PATH"

# Open the file in VS Code
code "$FILE_PATH"

# Confirm creation
echo "Journal entry created: $FILE_PATH"

