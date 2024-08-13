# GitHub Contribution Counter (GHCC)
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
3. Update refresh users to work with saved orgs
4. Update logging to work with -v
5. Update logging to work with -vv
6. Refactor to use output
7. Make all parameters consistently key: value