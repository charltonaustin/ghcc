require 'date'
require 'csv'
require_relative 'repository'
require_relative '../../shared/github_client'
require_relative '../../shared/logger'

client = get_client
logger = get_logger
owner = 'kin'
repos = %w[maestro ihop dot-com product-api rater-api sheng]

def refresh_pull_requests(client, owner, repos, logger)
  repos.each do |repo|
    logger.debug("Getting pull requests for #{repo}")
    repository_name = "#{owner}/#{repo}"

    has_saved = has_saved?(repository_name)
    unless has_saved
      logger.debug("no prs saved getting them all")
      client.auto_paginate = true
      pull_requests = client.pull_requests(repository_name, state: 'all')
      pull_requests.each do |pr|
        logger.debug("Saving pr #{pr.html_url}")
        save(pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
      end
      client.auto_paginate = false
      next
    end
    pull_request = client.pull_requests(repository_name, state: 'all', per_page: 1, page: 1)
    if get_latest[:number] >= pull_request[0].number
      logger.debug("no updates needed")
      next
    end
    if has_saved
      logger.debug("saving new prs")
      number_needed = pull_request[0].number - get_latest[:number]
      while number_needed > 0
        pull_requests = client.pull_requests(repository_name, state: 'all', per_page: 100, page: 1)
        pull_requests.each do |pr|
          logger.debug("Saving pr #{pr.html_url}")
          save(pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
          number_needed -= 1
          if number_needed <= 0
            break
          end
        end
      end
    end
  end
end

refresh_pull_requests(client, owner, repos, logger)
