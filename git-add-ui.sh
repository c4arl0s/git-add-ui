UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
MODIFIED_FILES=$(git ls-files -m)
ANSWER=$(dialog --checklist "Choose what you want to install:" 0 0 0 file mysql on file java on file git off --output-fd 1)
echo "Has elegido: $ANSWER"
echo "untracked files: $UNTRACKED_FILES"
echo "modified files: $MODIFIED_FILES"
git ls-files --others --exclude-standard | while read FILE
do
    echo "this is an untracked file: $FILE"
done
git ls-files -m | while read FILE
do
    echo "this is a modified file: $FILE"
done
