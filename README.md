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
UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
MODIFIED_FILES=$(git ls-files -m)
if [[ $UNTRACKED_FILES ]]; then
    let COUNTER=0
    LINE=$(git ls-files --others --exclude-standard | while read UNTRACKED_FILE
                                                      do 
                                                          let "COUNTER+=1"
                                                          echo "\"$UNTRACKED_FILE\" \"$COUNTER\" off"
                                                      done)
    echo $LINE;
    SELECTED_UNTRACKED_FILES=$(echo $LINE | xargs dialog --stdout --checklist "untracked files to add:" 0 0 0)
    echo $SELECTED_UNTRACKED_FILES | xargs git add
else
    echo  "untracked files dont exist"
fi

if [[ $MODIFIED_FILES ]]; then
    let COUNTER=0
    LINE=$(git ls-files -m | while read MODIFIED_FILE
                             do 
                                 let "COUNTER+=1"
                                 echo "\"$MODIFIED_FILE\" \"$COUNTER\" off"
                             done)
    echo $LINE
    SELECTED_MODIFIED_FILES=$(echo $LINE | xargs dialog --stdout --checklist "modified files to add:" 0 0 0)
    echo $SELECTED_MODIFIED_FILES | xargs git add
else
    echo  "modified files dont  exist"
fi
```
