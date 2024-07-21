# GitHub Contribution Counter (GHCC)
## To setup
```bash
bundle install
```
You have to export a variable called `GHCC_ACCESS_TOKEN` with classic Personal access GitHub token.
It needs to have the right permissions to get the information.
## To run
```bash
bundle exec ruby <name of command>.rb
```

## Script Commands
- `get_commits.rb`: Adds commit data to contributions.csv in the data folder.
- `get_github_org_members.rb`: Adds users to users.csv.
- `get_pull_requests.rb`: Adds pull requests to contributions.csv.
- `get_reviews.rb`: Adds reviews to contributions.csv. 

## CLI Commands
- `ghcc contributions`: Processes contributions.csv and prints people's contributions. 