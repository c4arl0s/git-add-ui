UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
MODIFIED_FILES=$(git ls-files -m)
if [[ $UNTRACKED_FILES ]]; then
    let COUNTER=0
    LINE=$(git ls-files --others --exclude-standard | while read UNTRACKED_FILE
    do
        let "COUNTER+=1" 
        echo "\"$COUNTER\" \"$UNTRACKED_FILE\" off"
    done)
    echo $LINE;
    SELECTED_FILES=$(echo $LINE | xargs dialog --stdout --checklist "untracked files to add:" 0 0 0)
    ADDED_FILES=$(echo $SELECTED_FILES | while read SELECTED_FILE
    do 
        echo "\"$SELECTED_FILE\""
    done)
    echo $ADDED_FILES
    git add $ADDED_FILES
else
    echo  "untracked files dont exist"
fi

if [[ $MODIFIED_FILES ]]; then
    let COUNTER=0
    LINE=$(git ls-files -m | while read MODIFIED_FILE
    do
        let "COUNTER+=1" 
        echo "\"$COUNTER\" \"$MODIFIED_FILES\" off"
    done)
    echo $LINE
    ANSWER=$(echo $LINE | xargs dialog --stdout --checklist "modified files to add:" 0 0 0)
    echo $ANSWER
    git add $ANSWER
else
    echo  "modified files dont  exist"
fi
