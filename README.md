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

<img width="1624" alt="Screen Shot 2022-04-02 at 1 24 52 p m" src="https://user-images.githubusercontent.com/24994818/161398167-ae4dc18e-5374-40f4-a37f-866b933e9172.png">

