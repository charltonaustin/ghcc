# frozen_string_literal: true

require_relative '../../shared/github_client'
require_relative 'repository'
require_relative '../repository'

def log_commits(commit, display_name, logger, repo)
  logger.debug("date: #{commit.commit.author.date}")
  logger.debug("username: #{display_name}")
  logger.debug("repo: #{repo}")
  logger.debug("commit.html_url: #{commit.html_url}")
end

def get_name(commit, db)
  display_name = commit.commit.committer.name
  maybe_username = get_user_name(db, commit.commit.committer.name)
  display_name = maybe_username if maybe_username
  display_name
end

def refresh_commits(db, repo, logger)
  logger.debug('write commits')
  git_client.list_commits(repo.to_s).map do |commit|
    display_name = get_name(commit, db)
    log_commits(commit, display_name, logger, repo)
    save_commit(db, commit.commit.author.date, display_name, repo, commit.html_url)
  end
end
