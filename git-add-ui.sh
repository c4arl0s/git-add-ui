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

warning_untracked_msg=
warning_modified_msg=

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { error "${ERROR_REPO}"; exit 1; }

#######################################
# A function to print out error messages 
#######################################
error() {
  echo "[🔴 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# A function to print out warning messages 
#######################################
warning() {
  echo "[🟡 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

are_you_sure_msg() {
  local selected_files=$1
  dialog --title "${ARE_YOU_SURE_MSG} ${selected_files}" \
    --yesno "continue?" 0 0
}

get_git_files() {
  local type="$1"
  if [[ "${type}" == "untracked" ]]; then
    git ls-files --others --exclude-standard
  else
    git ls-files -m
  fi
}

build_checklist_args() {
  local type="$1"
  local -n output_args_ref=$2
  local counter=0
  output_args_ref=()

  while IFS= read -r file || [[ -n "${file}" ]]; do
    [[ -z "${file}" ]] && continue
    counter=$((counter + 1))
    output_args_ref+=("${counter}" "${file}" "off")
  done < <(get_git_files "${type}")
}

add_selected_files() {
  local type="$1"
  local selected_indexes="$2"
  local -a files=()
  local -a selected_files=()

  # Populate files array
  while IFS= read -r file || [[ -n "${file}" ]]; do
    [[ -n "${file}" ]] && files+=("${file}")
  done < <(get_git_files "${type}")

  # Populate selected_files array (handles both space and newline separators)
  for idx in ${selected_indexes}; do
    if [[ "${idx}" =~ ^[0-9]+$ ]]; then
      if [[ ${idx} -gt 0 && ${idx} -le ${#files[@]} ]]; then
        selected_files+=("${files[idx-1]}")
      fi
    fi
  done

  [[ ${#selected_files[@]} -eq 0 ]] && return 0

  if are_you_sure_msg "${selected_files[*]}"; then
    if git add -- "${selected_files[@]}"; then
      echo "🟢 ${SUCCESS_MSG}"
      return 0
    else
      return 1 # git add failed
    fi
  else
    return 0 # User cancelled
  fi
}

# Main execution logic

untracked_exists=$(get_git_files "untracked")
if [[ -n "${untracked_exists}" ]]; then
  build_checklist_args "untracked" untracked_checklist_args
  selected_untracked_files=$(dialog --stdout --separate-output --checklist \
    "${UNTRACKED_FILES_MSG}" 0 0 0 "${untracked_checklist_args[@]}")
  dialog_status=$?
  
  if [[ ${dialog_status} -eq 0 ]]; then
    if [[ -z "${selected_untracked_files}" ]]; then
      warning_untracked_msg=${DIDNT_SELECT_UNT_MSG}
    else
      add_selected_files "untracked" "${selected_untracked_files}" || exit 1
    fi
  fi
else
  error "${UNTRACKED_ERROR_MSG}"
fi

modified_exists=$(get_git_files "modified")
if [[ -n "${modified_exists}" ]]; then
  build_checklist_args "modified" modified_checklist_args
  selected_modified_files=$(dialog --stdout --separate-output --checklist \
    "${MODIFIED_FILES_MSG}" 0 0 0 "${modified_checklist_args[@]}")
  dialog_status=$?
  
  if [[ ${dialog_status} -eq 0 ]]; then
    if [[ -z "${selected_modified_files}" ]]; then
      warning_modified_msg=${DIDNT_SELECT_MOD_MSG}
    else
      add_selected_files "modified" "${selected_modified_files}" || exit 1
    fi
  fi
else
  error "${MODIFIED_ERROR_MSG}"
fi

[[ -n "${warning_untracked_msg}" ]] && warning "${warning_untracked_msg}"
[[ -n "${warning_modified_msg}" ]] && warning "${warning_modified_msg}"
