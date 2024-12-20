# [go back to overview](https://github.com/c4arl0s#bash-scripts)

# [git-add-user-interface-script](https://github.com/c4arl0s/git-add-user-interface-script#go-back-to-overview)

1. Find out how to list untracked files using git command:

```console
git ls-files --others --exclude-standard
```

2. Find out how to list modified files using git command:

```console
git ls-files -m
```

3. You can pass standard ouput to dialog:

```console
echo $LINE | xargs dialog --stdout --checklist "untracked files to add:" 0 0 0)
```

# [Dependencies](https://github.com/c4arl0s/git-add-user-interface-script#git-add-user-interface-script)

```console
brew install dialog
```

# [How to use it](https://github.com/c4arl0s/git-add-user-interface-script#git-add-user-interface-script)

```console
./git-add-ui.sh
```

<img width="1624" alt="Screen Shot 2022-05-12 at 10 28 10 p m" src="https://user-images.githubusercontent.com/24994818/168206056-046d0310-8a9f-4a52-b83d-4003e5262d5c.png">

# [Code]()

```bash
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

[[ -n "${warning_untracked_msg}" ]] && warning ${warning_untracked_msg}
[[ -n "${warning_modified_msg}" ]] && warning ${warning_modified_msg}
```
