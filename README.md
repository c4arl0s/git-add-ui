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

<img width="995" alt="Screen Shot 2022-05-09 at 8 42 22 p m" src="https://user-images.githubusercontent.com/24994818/167525722-5d211bb2-9e18-4e9b-ba84-866a79310357.png">

<img width="424" alt="Screen Shot 2022-05-09 at 8 42 53 p m" src="https://user-images.githubusercontent.com/24994818/167525776-1652e713-4bf1-4e96-9e93-da97d8bf06e5.png">
