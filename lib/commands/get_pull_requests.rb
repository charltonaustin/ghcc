require 'octokit'
require 'date'
require 'csv'
require_relative 'repository/pull_request'

ACCESS_TOKEN = ENV['GHCC_ACCESS_TOKEN']
client = Octokit::Client.new(access_token: ACCESS_TOKEN)
client.default_media_type = "application/vnd.github+json"
client.auto_paginate = false

owner = 'kin'
repos = %w[maestro ihop dot-com product-api rater-api sheng]
repos.each do |repo|
  puts "Getting pull requests for #{repo}"
  repository_name = "#{owner}/#{repo}"

  has_saved = has_saved?(repository_name)
  unless has_saved
    puts "no prs saved getting them all"
    client.auto_paginate = true
    pull_requests = client.pull_requests(repository_name, state: 'all')
    pull_requests.each do |pr|
      puts "Saving pr #{pr.html_url}"
      save(pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
    end
    client.auto_paginate = false
    next
  end
  pull_request = client.pull_requests(repository_name, state: 'all', per_page: 1, page: 1)
  if get_latest[:number] >= pull_request[0].number
    puts "no updates needed"
    next
  end
  if has_saved
    puts "saving new prs"
    number_needed = pull_request[0].number - get_latest[:number]
    while number_needed > 0
      pull_requests = client.pull_requests(repository_name, state: 'all', per_page: 100, page: 1)
      pull_requests.each do |pr|
        puts "Saving pr #{pr.html_url}"
        save(pr.created_at, pr.user.login, pr.html_url, repository_name, pr.number)
        number_needed -= 1
        if number_needed  <= 0
          break
        end
      end
    end
  end
end
