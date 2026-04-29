#!/usr/bin/env bash
#
# git-add-ui script uses an user interface to add files to the stage area

readonly UNTRACKED_FILES_MSG='Untracked files to add, select them:'
readonly MODIFIED_FILES_MSG='Modified files to add, select them:'

readonly UNTRACKED_ERROR_MSG='Untracked files dont exist'
readonly MODIFIED_ERROR_MSG='Modified files dont exist'

readonly DIDNT_SELECT_UNT_MSG='You did not select any untracked file'
readonly DIDNT_SELECT_MOD_MSG='You did not select any modified file'

readonly SUCCESS_MSG='Selected files were staged'
readonly ERROR_REPO="Current directory is not a git repository"

readonly ARE_YOU_SURE_MSG='Are you sure you want to add these files?:'

# Dependency error messages
readonly DIALOG_MISSING_MSG='dialog command not found. Please install dialog package.'
readonly GIT_MISSING_MSG='git command not found. Please install git package.'
readonly DIALOG_INSTALL_INSTRUCTIONS='Install dialog using: brew install dialog (macOS) or sudo apt-get install dialog (Ubuntu/Debian)'
readonly GIT_INSTALL_INSTRUCTIONS='Install git using: brew install git (macOS) or sudo apt-get install git (Ubuntu/Debian)'

warning_untracked_msg=
warning_modified_msg=

#######################################
# Check if required dependencies are installed
# Globals: None
# Arguments: None
# Returns: 0 if all dependencies are available, 1 otherwise
#######################################
check_dependencies() {
  local missing_deps=0
  
  # Check if dialog is installed
  if ! command -v dialog >/dev/null 2>&1; then
    error "${DIALOG_MISSING_MSG}"
    echo "💡 ${DIALOG_INSTALL_INSTRUCTIONS}" >&2
    missing_deps=1
  fi
  
  # Check if git is installed
  if ! command -v git >/dev/null 2>&1; then
    error "${GIT_MISSING_MSG}"
    echo "💡 ${GIT_INSTALL_INSTRUCTIONS}" >&2
    missing_deps=1
  fi
  
  if [[ ${missing_deps} -eq 1 ]]; then
    echo "❌ Please install the missing dependencies and try again." >&2
    return 1
  fi
  
  return 0
}

# Check dependencies before proceeding
check_dependencies || return 1

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { error ${ERROR_REPO}; return 1; }

untracked_files=$(git ls-files --others --exclude-standard)
modified_files=$(git ls-files -m)

#######################################
# A function to print out error messages 
# Globals:
#   
# Arguments:
#   None
#######################################
error() {
  echo "[🔴 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# A function to print out warning messages 
# Globals:
#   
# Arguments:
#   None
#######################################
warning() {
  echo "[🟡 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

are_you_sure_msg() {
  selected_untracked_files=$1
  dialog --title "${ARE_YOU_SURE_MSG} ${selected_untracked_files}" \
    --yesno "continue?" 0 0
}

if [[ -n ${untracked_files} ]]; then
  let counter=0
  line=$(git ls-files --others --exclude-standard \
    | while read untracked_file; do 
        let "counter+=1"
        echo "\"${untracked_file}\" \"${counter}\" off"
      done)
  echo $line
  selected_untracked_files=$(echo "${line}" \
    | xargs dialog --stdout --checklist ${UNTRACKED_FILES_MSG} 20 100 100 )
  [[ -n "${selected_untracked_files}" ]] \
    && are_you_sure_msg ${selected_untracked_files} \
    && echo ${selected_untracked_files} | xargs git add \
    && echo "🟢 ${SUCCESS_MSG}" \
    || warning_untracked_msg=${DIDNT_SELECT_UNT_MSG}
else
  error ${UNTRACKED_ERROR_MSG}
fi

if [[ -n ${modified_files} ]]; then
  let counter=0
  line=$(git ls-files -m \
    | while read modified_file; do 
        let "counter+=1"
        echo "\"${modified_file}\" \"${counter}\" off"
      done)
  echo $line
  selected_modified_files=$(echo "${line}" \
    | xargs dialog --stdout --checklist ${MODIFIED_FILES_MSG} 20 100 100 )
  [[ -n "${selected_modified_files}" ]] \
    && are_you_sure_msg ${selected_modified_files} \
    && echo ${selected_modified_files} | xargs git add \
    && echo "🟢 ${SUCCESS_MSG}" \
    || warning_modified_msg=${DIDNT_SELECT_MOD_MSG}
else
  error ${MODIFIED_ERROR_MSG}
fi

[[ -n "${warning_untracked_msg}" ]] && warning ${warning_untracked_msg}
[[ -n "${warning_modified_msg}" ]] && warning ${warning_modified_msg}
