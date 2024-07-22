# GitHub Contribution Counter (GHCC)
## To setup
```bash
bundle install
```
You have to export a variable called `GHCC_ACCESS_TOKEN` with classic Personal access GitHub token.
It needs to have the right permissions to get the information.

## Script Commands
### To run
```bash
bundle exec ruby <name of command>.rb
```
- `get_github_org_members.rb`: Saves users.
- `get_pull_requests.rb`: Saves pull requests to contributions.
- `get_reviews.rb`: Saves reviews to contributions. 

## CLI Commands
### To run
Before you install it cd to the directory and run the following: 
```bash
./ghcc install
```
After you install it you can simply run the command
```bash
ghcc <command>
```
- `ghcc commits`: Saves commits to contributions.
- `ghcc contributions`: Processes contributions and prints them. 
- `ghcc run_migrations`: A development script that updates the data model. 
- `ghcc install`: Installs the current version of `ghcc` file. 