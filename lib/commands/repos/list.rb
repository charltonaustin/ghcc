require_relative 'repository'

def list_repos(db)
  repos = list_repos_from(db)
  repos.each do |repo|
    puts repo
  end
end