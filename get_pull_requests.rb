require 'octokit'
require 'date'
require 'csv'

ACCESS_TOKEN = ENV['GHCC_ACCESS_TOKEN']

client = Octokit::Client.new(access_token: ACCESS_TOKEN)
client.default_media_type = "application/vnd.github+json"
client.auto_paginate = false

owner = 'kin'
repos = %w[maestro ihop dot-com product-api rater-api]
repos.each do |repo|
  repository = client.repository("#{owner}/#{repo}")

  def fetch_all(client, method, *args)
    puts "method: #{method}"
    results = []
    page = 1
    loop do
      puts "looping #{page}"
      options = args.last.is_a?(Hash) ? args.pop.clone : {}
      options[:page] = page
      args << options
      puts args
      response = client.send(method, *args)
      break if response.empty?
      break if page >= 40
      results.concat(response)
      page += 1
    end
    results
  end

  pull_requests = fetch_all(client, :pull_requests, "#{owner}/#{repo}", state: 'all', direction: 'desc', per_page: 100,)

  puts "Repository: #{repository.full_name}"
  puts "Description: #{repository.description}"

  puts "\nwrite pull requests to csv"
  already_exists = File.exist?("data/contributions.csv")
  CSV.open("data/contributions.csv", 'a') do |csv|
    csv << ['TYPE', 'Created At', 'User', 'REPOSITORY', 'URL', 'Number', 'Title'] unless already_exists
    pull_requests.each do |pr|
      csv << ['PR', pr.created_at, pr.user.login, repo, pr.html_url, pr.number, pr.title,]
    end
  end
end
