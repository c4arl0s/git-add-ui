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
