<!-- TOC -->
* [GitHub Contribution Counter (GHCC)](#github-contribution-counter-ghcc)
  * [Usage](#usage)
  * [Contributing](#contributing)
    * [Dependencies](#dependencies)
    * [To setup](#to-setup)
    * [To run lint](#to-run-lint)
    * [To run tests](#to-run-tests)
    * [CLI Commands](#cli-commands)
      * [To run](#to-run)
    * [To do](#to-do)
<!-- TOC -->

# GitHub Contribution Counter (GHCC)
This is a small program that allows a user to display contributions made by GitHub users.

## Usage
The basic flow is something like.
- Add in an org.
- Refresh users for that org.
- Add in a repo.
- Refresh prs, commits, and reviews.
- Display contributions for your users.

```shell
$ ghcc orgs add <name>
$ ghcc users refresh -v
$ ghcc repos add -n <repo name> -o <org name> -v
$ ghcc prs -v
$ ghcc reviews refresh -v
$ ghcc contributions all
```

## Contributing
### Dependencies
For ruby please see the `.ruby-version` file
### To setup
```sh
bundle install
```
You have to export a variable called `GHCC_ACCESS_TOKEN` with classic Personal access GitHub token.
It needs to have the right permissions to get the information.

### To run lint
See the lib/scripts file

### To run tests
See the lib/scripts file

### CLI Commands
#### To run
Before you install it cd to the root directory and run the following:
```sh
./ghcc dev install
./ghcc dev run_migrations
```

You might run into issues with creating symlinks. Try sudo if you dare.

DB isn't created on its own:
```sh
sqlite3 ghcc.db
```

depending on where your db is located, you might have to change
the connection location in `lib/shared/database.rb`


After you install it you can simply run the command
```sh
ghcc help
```

### To do
1. Write tests
   1. Make `lib/commands/users/list_spec.rb` into a unit test
2. Refactor `lib/commands/contributions` to be sane
3. Add in github actions build
4. Make commits associated with a pr not double counted
    1. Pull commits for PRs
    2. Update contributions from commits to check that they are not a part of a PR
    3. Update commits to pull from to process on org or repo
5. Automatic refresh of pull requests, reviews, and commits
