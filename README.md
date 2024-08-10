# GitHub Contribution Counter (GHCC)
## Dependencies
For ruby please see the `.ruby-version` file
## To setup
```bash
bundle install
```
You have to export a variable called `GHCC_ACCESS_TOKEN` with classic Personal access GitHub token.
It needs to have the right permissions to get the information.

## To run lint
```bash
rubocop -A 
```

## To run tests
```bash
bundle exec turbo_tests **/*_spec.rb --format documentation 
```

## CLI Commands
### To run
Before you install it cd to the directory and run the following: 
```bash
./ghcc install
```
After you install it you can simply run the command
```bash
ghcc help
```

## To do
1. Add in pre-commit hook
2. Add in tests
3. Add in github build
4. Update refresh users to work with saved orgs
5. Update logging to work with -v
6. Update logging to work with -vv
7. Refactor to use output
8. Make all parameters consistently key: value