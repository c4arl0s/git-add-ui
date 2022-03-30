UNTRACKED_FILES=`git ls-files --others --exclude-standard`
echo $UNTRACKED_FILES
MODIFIED_FILES=`git ls-files -m`
echo $MODIFIED_FILES
# ANSWER=$(dialog --title "Files to add to stagging area" --stdout --checklist "Select all the files:" 0 0 5 "$UNTRACKED_FILES")
# echo "Has elegido: $ANSWER"
