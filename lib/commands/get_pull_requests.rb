require 'octokit'
require 'date'
require 'csv'

ACCESS_TOKEN = ENV['GHCC_ACCESS_TOKEN']

client = Octokit::Client.new(access_token: ACCESS_TOKEN)
client.default_media_type = "application/vnd.github+json"
client.auto_paginate = true

owner = 'kin'
repos = %w[maestro ihop dot-com product-api rater-api]
repos.each do |repo|
  repository = client.repository("#{owner}/#{repo}")
  
  pull_requests = client.pull_requests("#{owner}/#{repo}", state: 'all')

  puts "Repository: #{repository.full_name}"
  puts "\nwrite pull requests to csv"
  already_exists = File.exist?("#{__dir__}/../../data/contributions.csv")
  CSV.open("data/contributions.csv", 'a') do |csv|
    csv << ['Type', 'Created At', 'User', 'Repository', 'URL'] unless already_exists
    pull_requests.each do |pr|
      csv << ['PR', pr.created_at, pr.user.login, repo, pr.html_url]
    end
  end
  puts "----------------------------"
end
