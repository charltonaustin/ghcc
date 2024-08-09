require_relative '../../shared/github_client'
require_relative 'repository'
require_relative '../repository'

def refresh_commits(db, repo, logger)
  client = get_client
  commits = client.list_commits("#{repo}")
  logger.debug("write commits")

  commits.map do |commit|
    display_name = commit.commit.committer.name
    maybe_username = get_user_name(db, commit.commit.committer.name)
    if maybe_username
      display_name = maybe_username
    end
    logger.debug("date: #{commit.commit.author.date}")
    logger.debug("username: #{display_name}")
    logger.debug("repo: #{repo}")
    logger.debug("commit.html_url: #{commit.html_url}")
    save_commit(db, commit.commit.author.date, display_name, repo, commit.html_url)
  end
end
