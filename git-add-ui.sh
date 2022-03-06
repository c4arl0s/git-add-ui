FILES=$(git status | grep "modified:" | cut -f 2 -d ":" | sed -e "s/^[ \t]*//" | cut -f 1 -d " ")
ONE_LINE_FILES=$(for FILE in $FILES; do printf "$FILE file on "; done)
ANSWER=$(dialog --title "Files to add to stagging area" --stdout --checklist "Select all the files:" 0 0 5 "$ONE_LINE_FILES")
echo "Has elegido: $ANSWER"
git add "$ANSWER"
