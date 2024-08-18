# GitHub Contribution Counter (GHCC)
This is a small program that allows a user to display contributions made by GitHub users.
The basic flow is something like.
- Add in an org.
- Refresh users for that org.
- Add in a repo.
- Refresh prs, commits, and reviews.
- Display contributions for your users.

## Dependencies
For ruby please see the `.ruby-version` file
## To setup
```sh
bundle install
```
You have to export a variable called `GHCC_ACCESS_TOKEN` with classic Personal access GitHub token.
It needs to have the right permissions to get the information.

## To run lint
See the lib/scripts file

## To run tests
See the lib/scripts file

## CLI Commands
### To run
Before you install it cd to the directory and run the following: 
```sh
./ghcc install
```
After you install it you can simply run the command
```sh
ghcc help
```

## To do
1. Add in tests
2. Add in github build
3. Automatic refresh of pull requests, reviews, and commits
4. Make commits associated with a pr not double counted