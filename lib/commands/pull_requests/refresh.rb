require_relative 'repository'

def update_pull_requests(client, db, logger, repository_name)
  logger.debug("no prs saved getting them all")
  client.auto_paginate = true
  pull_requests = client.pull_requests(repository_name, state: 'all')
  pull_requests.each do |pr|
    logger.debug("Saving pr #{pr.html_url}")
    save_pull_request(db, pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
  end
  client.auto_paginate = false
end

def get_remaining_pull_requests(client, db, logger, pull_request, repository_name)
  logger.debug("saving new prs")
  number_needed = pull_request[0].number - get_latest_pull_requests(db)[:number]
  while number_needed > 0
    pull_requests = client.pull_requests(repository_name, state: 'all', per_page: 100, page: 1)
    pull_requests.each do |pr|
      logger.debug("Saving pr #{pr.html_url}")
      save_pull_request(db, pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
      number_needed -= 1
      if number_needed <= 0
        break
      end
    end
  end
end

def refresh_pull_requests(db, client, owner, repos, logger)
  repos.each do |repo|
    repository_name = "#{owner}/#{repo}"
    logger.debug("Getting pull requests for #{repository_name}")
    has_saved = has_saved_pull_request?(db, repository_name)
    logger.debug("has_saved #{has_saved}")
    unless has_saved
      update_pull_requests(client, db, logger, repository_name)
      next
    end
    pull_request = client.pull_requests(repository_name, state: 'all', per_page: 1, page: 1)
    if get_latest_pull_requests(db)[:number] >= pull_request[0].number
      logger.debug("no updates needed")
      next
    end
    if has_saved
      get_remaining_pull_requests(client, db, logger, pull_request, repository_name)
    end
  end
end