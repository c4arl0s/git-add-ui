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

untracked_files=$(git ls-files --others --exclude-standard)
modified_files=$(git ls-files -m)

readonly UNTRACKED_FILES_MSG='Untracked files to add, select them:'
readonly MODIFIED_FILES_MSG='Modified files to add, select them:'

readonly UNTRACKED_ERROR_MSG='Untracked files dont exist'
readonly MODIFIED_ERROR_MSG='Modified files dont exist'

readonly DIDNT_SELECT_UNT_MSG='🟡 You did not select any untracked file'
readonly DIDNT_SELECT_MOD_MSG='🟡 You did not select any modified file'

warning_untracked_msg=
warning_modified_msg=

#######################################
# A function to print out error messages 
# Globals:
#   
# Arguments:
#   None
#######################################
function error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if [[ ${untracked_files} ]]; then
  let counter=0
  line=$(git ls-files --others --exclude-standard \
    | while read untracked_file; do 
      let "counter+=1"
      echo "\"${untracked_file}\" \"${counter}\" off"
      done)
  echo ${line};
  selected_untracked_files=$(echo ${line} | xargs dialog --stdout --checklist ${UNTRACKED_FILES_MSG} 0 0 0)
  [[ "${selected_untracked_files}" != "" ]] \
    && echo ${selected_untracked_files} | xargs git add \
    || warning_untracked_msg=${DIDNT_SELECT_UNT_MSG}
else
  echo ${UNTRACKED_ERROR_MSG}
fi

if [[ ${modified_files} ]]; then
  let counter=0
  line=$(git ls-files -m | 
    while read modified_file; do 
      let "counter+=1"
      echo "\"${modified_file}\" \"${counter}\" off"
    done)
  echo ${line}
  selected_modified_files=$(echo ${line} | xargs dialog --stdout --checklist ${MODIFIED_FILES_MSG} 0 0 0)
  [[ "${selected_modified_files}" != "" ]] \
    && echo ${selected_modified_files} | xargs git add \
    || warning_modified_msg=${DIDNT_SELECT_MOD_MSG}
else
    echo ${MODIFIED_ERROR_MSG}
fi

[[ "${warning_untracked_msg}" != "" ]] && error ${warning_untracked_msg}
[[ "${warning_modified_msg}" != "" ]] && error ${warning_modified_msg}
```
