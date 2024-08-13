# frozen_string_literal: true

require_relative 'repository'
require_relative '../read_repository'

def update_pull_requests(client, db, logger, repository_name)
  logger.debug('no prs saved getting them all')
  client.auto_paginate = true
  pull_requests = client.pull_requests(repository_name, state: 'all')
  pull_requests.each do |pr|
    logger.debug("Saving pr #{pr.html_url}")
    save_pull_request(db, pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
  end
  client.auto_paginate = false
end

def get_more_prs(client, db, logger, number_needed, repository_name)
  pull_requests = client.pull_requests(repository_name, state: 'all', per_page: 100, page: 1)
  pull_requests.each do |pr|
    logger.debug("Saving pr #{pr.html_url}")
    save_pull_request(db, pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
    number_needed -= 1
    break if number_needed <= 0
  end
end

def get_remaining_pull_requests(client, db, logger, pull_request, repository_name)
  logger.debug('saving new prs')
  number_needed = pull_request[0].number - get_latest_pull_requests(db)[:number]
  get_more_prs(client, db, logger, number_needed, repository_name) while number_needed.positive?
end

def check_if_saved(db, logger, repo)
  repository_name = "#{repo[:organization]}/#{repo[:name]}"
  logger.debug("Getting pull requests for #{repository_name}")
  has_saved = saved_pull_request?(db, repository_name)
  logger.debug("has_saved #{has_saved}")
  [has_saved, repository_name]
end

def latest_pr?(db, pull_request)
  get_latest_pull_requests(db)[:number] >= pull_request[0].number
end

def process_latest(client, latest_pr, logger, repository_name)
  pull_request = client.pull_requests(repository_name, state: 'all', per_page: 1, page: 1)
  logger.debug('no updates needed') if latest_pr
  pull_request
end

def process_saved(client, db, logger, repo)
  has_saved, repository_name = check_if_saved(db, logger, repo)
  update_pull_requests(client, db, logger, repository_name) unless has_saved
  [has_saved, repository_name]
end

def process_loop(client, db, logger, repos)
  repos.each do |repo|
    has_saved, repository_name = process_saved(client, db, logger, repo)
    next unless has_saved

    latest_pr = latest_pr?(db, pull_request)
    pull_request = process_latest(client, latest_pr, logger, repository_name)
    next if latest_pr

    get_remaining_pull_requests(client, db, logger, pull_request, repository_name) if has_saved
  end
end

def refresh_pull_requests(db, client, logger)
  repos = get_repos_to_process(db)
  process_loop(client, db, logger, repos)
end
