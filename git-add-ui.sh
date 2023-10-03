#!/usr/bin/env bash

UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
MODIFIED_FILES=$(git ls-files -m)

UNTRACKED_FILES_MSG="Untracked files to add:"
MODIFIED_FILES_MSG="Modified files to add:"

UNTRACKED_ERROR_MSG="Untracked files don't exist"
MODIFIED_ERROR_MSG="Modified files don't exist"

if [[ $UNTRACKED_FILES ]]; then
    let COUNTER=0
    LINE=$(git ls-files --others --exclude-standard | 
           while read UNTRACKED_FILE
           do 
               let "COUNTER+=1"
               echo "\"$UNTRACKED_FILE\" \"$COUNTER\" off"
           done
          )
    echo $LINE;
    SELECTED_UNTRACKED_FILES=$(echo $LINE | xargs dialog --stdout --checklist $UNTRACKED_FILES_MSG 0 0 0)
    echo $SELECTED_UNTRACKED_FILES | xargs git add
else
    echo $UNTRACKED_ERROR_MSG
fi

if [[ $MODIFIED_FILES ]]; then
    let COUNTER=0
    LINE=$(git ls-files -m | 
           while read MODIFIED_FILE
           do 
               let "COUNTER+=1"
               echo "\"$MODIFIED_FILE\" \"$COUNTER\" off"
           done
          )
    echo $LINE
    SELECTED_MODIFIED_FILES=$(echo $LINE | xargs dialog --stdout --checklist $MODIFIED_FILES_MSG 0 0 0)
    echo $SELECTED_MODIFIED_FILES | xargs git add
else
    echo $MODIFIED_ERROR_MSG
fi
