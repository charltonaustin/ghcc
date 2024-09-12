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
$ ghcc users refresh
$ ghcc repos add -n <repo name> -o <org name>
$ ghcc prs
$ ghcc reviews refresh
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
./ghcc install
```
After you install it you can simply run the command
```sh
ghcc help
```

### To do
1. Write tests
2. Add in github actions build
3. Make commits associated with a pr not double counted
    1. Pull commits for PRs
    2. Update contributions from commits to check that they are not a part of a PR
    3. Update commits to pull from to process on org or repo
4. Automatic refresh of pull requests, reviews, and commits
