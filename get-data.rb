require 'octokit'
require 'date'

# GitHub credentials
ACCESS_TOKEN = ''  # Replace with your GitHub Personal Access Token

# Initialize Octokit client
client = Octokit::Client.new(access_token: ACCESS_TOKEN)
client.default_media_type = "application/vnd.github+json"
client.auto_paginate = false

# Repository information
owner = 'kin'  # Replace with the repository owner
repo = 'dot-com'    # Replace with the repository name

# Fetch repository details
repository = client.repository("#{owner}/#{repo}")

# Fetch last 10 pull requests
pull_requests = client.pull_requests("#{owner}/#{repo}", state: 'all', per_page: 10)

# Fetch last 10 commits
commits = client.commits("#{owner}/#{repo}", per_page: 10)

# Fetch last 10 pull request reviews
pull_request_numbers = pull_requests.map(&:number)
reviews = pull_request_numbers.flat_map do |pr_number|
  client.pull_request_reviews("#{owner}/#{repo}", pr_number)
end.take(10)

# Output repository details
puts "Repository: #{repository.full_name}"
puts "Description: #{repository.description}"


# Output last 10 pull requests
puts "\nLast 10 Pull Requests:"
pull_requests.each do |pr|
  puts "#{pr.created_at}: #{pr.user.login} #{pr.title}  (#{pr.html_url})"
end

# Output last 10 commits
puts "\nLast 10 Commits:"
commits.each do |commit|
  puts "#{commit.commit.author.date}: #{commit.commit.author.login} (#{commit.html_url})"
end

# Output last 10 pull request reviews
puts "\nLast 10 Pull Request Reviews:"
reviews.each do |review|
  puts "#{review.submitted_at}: #{review.user.login} (#{review.html_url})"
end