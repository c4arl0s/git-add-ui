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
  selected_files=$1
  dialog --title "${ARE_YOU_SURE_MSG} ${selected_files}" \
    --yesno "continue?" 0 0
}

build_checklist_args() {
  local files_list="$1"
  local -n output_args_ref=$2
  local counter=0
  output_args_ref=()

  while IFS= read -r file; do
    [[ -z "${file}" ]] && continue
    counter=$((counter + 1))
    output_args_ref+=("${counter}" "${file}" "off")
  done <<< "${files_list}"
}

add_selected_files() {
  local files_list="$1"
  local selected_indexes="$2"
  local -a files=()
  local -a selected_files=()
  local selected_index

  while IFS= read -r file; do
    [[ -z "${file}" ]] && continue
    files+=("${file}")
  done <<< "${files_list}"

  while IFS= read -r selected_index; do
    [[ -z "${selected_index}" ]] && continue
    selected_files+=("${files[selected_index-1]}")
  done <<< "${selected_indexes}"

  [[ ${#selected_files[@]} -eq 0 ]] && return 1

  are_you_sure_msg "${selected_files[*]}" \
    && git add -- "${selected_files[@]}" \
    && echo "🟢 ${SUCCESS_MSG}"
}

if [[ -n ${untracked_files} ]]; then
  build_checklist_args "${untracked_files}" untracked_checklist_args
  temp_untracked=$(mktemp)
  dialog --separate-output --no-collapse --checklist \
    "${UNTRACKED_FILES_MSG}" 0 0 0 "${untracked_checklist_args[@]}" 2> "${temp_untracked}"
  selected_untracked_files=$(cat "${temp_untracked}")
  rm -f "${temp_untracked}"

  [[ -n "${selected_untracked_files}" ]] \
    && add_selected_files "${untracked_files}" "${selected_untracked_files}" \
    || warning_untracked_msg=${DIDNT_SELECT_UNT_MSG}
else
  error "${UNTRACKED_ERROR_MSG}"
fi

if [[ -n ${modified_files} ]]; then
  build_checklist_args "${modified_files}" modified_checklist_args
  temp_modified=$(mktemp)
  dialog --separate-output --no-collapse --checklist \
    "${MODIFIED_FILES_MSG}" 0 0 0 "${modified_checklist_args[@]}" 2> "${temp_modified}"
  selected_modified_files=$(cat "${temp_modified}")
  rm -f "${temp_modified}"

  [[ -n "${selected_modified_files}" ]] \
    && add_selected_files "${modified_files}" "${selected_modified_files}" \
    || warning_modified_msg=${DIDNT_SELECT_MOD_MSG}
else
  error "${MODIFIED_ERROR_MSG}"
fi

[[ -n "${warning_untracked_msg}" ]] && warning "${warning_untracked_msg}"
[[ -n "${warning_modified_msg}" ]] && warning "${warning_modified_msg}"
