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

### Installation

1. Clone or download this repository and `cd` into the project directory.

2. Make the install script executable (if needed):

   ```sh
   chmod +x install.sh
   ```

3. Run the installer:

   ```sh
   ./install.sh
   ```

### Usage

Run the script from any valid git repository directpry:
   ```bash
   git-add-ui
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
