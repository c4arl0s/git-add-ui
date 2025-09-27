# Git Add UI Script

A user-friendly bash script that provides an interactive interface for adding files to Git's staging area using dialog boxes.

[← Back to overview](https://github.com/c4arl0s#bash-scripts)

## 📋 Description

This script simplifies the process of adding files to Git by providing an interactive checklist interface. Instead of manually typing `git add` commands, you can visually select which files to stage through a user-friendly dialog interface.

## ✨ Features

- **Interactive file selection**: Choose files using checkboxes in a dialog interface
- **Separate handling**: Distinguishes between untracked and modified files
- **Confirmation dialog**: Asks for confirmation before staging selected files
- **Error handling**: Provides clear error messages and warnings
- **Git repository validation**: Ensures you're in a valid Git repository
- **Timestamped logging**: All messages include timestamps for better tracking

## 🚀 Quick Start

### Prerequisites

Install the required dependency:

```bash
# macOS (using Homebrew)
brew install dialog

# Ubuntu/Debian
sudo apt-get install dialog

# CentOS/RHEL
sudo yum install dialog
```

### Usage

1. Make the script executable:
   ```bash
   chmod +x git-add-ui.sh
   ```

2. Run the script:
   ```bash
   ./git-add-ui.sh
   ```

3. Use the interactive interface to select files and confirm your choices.

## 📸 Screenshot

<img width="1624" alt="Git Add UI Script Interface" src="https://user-images.githubusercontent.com/24994818/168206056-046d0310-8a9f-4a52-b83d-4003e5262d5c.png">

## 🔧 How It Works

The script uses Git commands to identify files and dialog for user interaction:

1. **List untracked files**:
   ```bash
   git ls-files --others --exclude-standard
   ```

2. **List modified files**:
   ```bash
   git ls-files -m
   ```

3. **Create interactive checklists**:
   ```bash
   dialog --stdout --checklist "Select files:" 0 0 0
   ```

## 📝 Source Code

The complete source code of the script:

```bash
#!/usr/bin/env bash
#
# git-add-ui script uses an user interface to add files to the stage area

# Constants for user messages
readonly UNTRACKED_FILES_MSG='Untracked files to add, select them:'
readonly MODIFIED_FILES_MSG='Modified files to add, select them:'

readonly UNTRACKED_ERROR_MSG='Untracked files dont exist'
readonly MODIFIED_ERROR_MSG='Modified files dont exist'

readonly DIDNT_SELECT_UNT_MSG='You did not select any untracked file'
readonly DIDNT_SELECT_MOD_MSG='You did not select any modified file'

readonly SUCCESS_MSG='Selected files were staged'
readonly ERROR_REPO="Current directory is not a git repository"

readonly ARE_YOU_SURE_MSG='Are you sure you want to add these files?:'

# Global variables for warning messages
warning_untracked_msg=
warning_modified_msg=

# Validate Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { error ${ERROR_REPO}; return 1; }

# Get file lists
untracked_files=$(git ls-files --others --exclude-standard)
modified_files=$(git ls-files -m)

#######################################
# A function to print out error messages 
# Globals: None
# Arguments: Error message string
#######################################
error() {
  echo "[🔴 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# A function to print out warning messages 
# Globals: None
# Arguments: Warning message string
#######################################
warning() {
  echo "[🟡 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# Display confirmation dialog for selected files
# Globals: None
# Arguments: Selected files string
#######################################
are_you_sure_msg() {
  selected_untracked_files=$1
  dialog --title "${ARE_YOU_SURE_MSG} ${selected_untracked_files}" \
    --yesno "continue?" 0 0
}

# Process untracked files
if [[ -n ${untracked_files} ]]; then
  let counter=0
  line=$(git ls-files --others --exclude-standard \
    | while read untracked_file; do 
        let "counter+=1"
        echo "\"${untracked_file}\" \"${counter}\" off"
      done)
  selected_untracked_files=$(echo "${line}" \
    | xargs dialog --stdout --checklist ${UNTRACKED_FILES_MSG} 0 0 0)
  [[ -n "${selected_untracked_files}" ]] \
    && are_you_sure_msg ${selected_untracked_files} \
    && echo ${selected_untracked_files} | xargs git add \
    && echo "🟢 ${SUCCESS_MSG}" \
    || warning_untracked_msg=${DIDNT_SELECT_UNT_MSG}
else
  error ${UNTRACKED_ERROR_MSG}
fi

# Process modified files
if [[ -n ${modified_files} ]]; then
  let counter=0
  line=$(git ls-files -m \
    | while read modified_file; do 
        let "counter+=1"
        echo "\"${modified_file}\" \"${counter}\" off"
      done)
  selected_modified_files=$(echo "${line}" \
    | xargs dialog --stdout --checklist ${MODIFIED_FILES_MSG} 0 0 0)
  [[ -n "${selected_modified_files}" ]] \
    && are_you_sure_msg ${selected_modified_files} \
    && echo ${selected_modified_files} | xargs git add \
    && echo "🟢 ${SUCCESS_MSG}" \
    || warning_modified_msg=${DIDNT_SELECT_MOD_MSG}
else
  error ${MODIFIED_ERROR_MSG}
fi

# Display warning messages if any
[[ -n "${warning_untracked_msg}" ]] && warning ${warning_untracked_msg}
[[ -n "${warning_modified_msg}" ]] && warning ${warning_modified_msg}
```

## 🛠️ Technical Details

### Dependencies
- **dialog**: Required for creating interactive dialog boxes
- **git**: Required for Git operations
- **bash**: Shell environment

### File Structure
The script handles two types of files:
- **Untracked files**: New files not yet added to Git
- **Modified files**: Existing tracked files with changes

### Error Handling
- Validates Git repository before execution
- Provides timestamped error and warning messages
- Gracefully handles cases with no files to process

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub.
