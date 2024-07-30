# GitHub Contribution Counter (GHCC)
## Dependencies
For ruby please see the `.ruby-version` file
## To setup
```bash
bundle install
```
You have to export a variable called `GHCC_ACCESS_TOKEN` with classic Personal access GitHub token.
It needs to have the right permissions to get the information.

## To run tests
```bash
bundle exec rspec  --pattern **/*_spec.rb 
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
1. Update refresh users to work with saved orgs
2. Update logging to work with -v
3. Update logging to work with -vv
4. Add in tests
5. Refactor to use output