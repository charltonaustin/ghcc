require 'octokit'
require 'date'
require 'csv'

ACCESS_TOKEN = ENV['GHCC_ACCESS_TOKEN']
def csv_to_hash(file_name)
  usernames = {}
  CSV.foreach(file_name, headers: true) do |row|
    usernames[row[0].strip.to_sym] = row[1].strip
  end
  usernames
end

usernames = csv_to_hash('data/users.csv')

client = Octokit::Client.new(access_token: ACCESS_TOKEN)
client.default_media_type = "application/vnd.github+json"
client.auto_paginate = true

owner = 'kin'
repo = 'report-service'

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
    break if page >= 20
    results.concat(response)
    page += 1
  end
  results
end

pull_requests = fetch_all(client, :commits, "#{owner}/#{repo}", per_page: 100,)
puts "Repository: #{repository.full_name}"
puts "Description: #{repository.description}"

puts "\nwrite commits to csv"
already_exists = File.exist?("./data/contributions.csv")
CSV.open("data/contributions.csv", 'a') do |csv|

  csv << ['TYPE', 'Created At', 'User', 'REPOSITORY', 'URL', 'Number', 'Title'] unless already_exists

  pull_requests.each do |commit|
    username = commit.commit.committer.name
    if usernames.key?(commit.commit.committer.name.to_sym)
      username = usernames[commit.commit.committer.name.to_sym]
    end
    csv << ["COMMIT", commit.commit.author.date, username, repo, commit.html_url, nil, nil]
  end
end