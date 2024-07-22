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
def refresh_commits(repo)
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)
  client.default_media_type = "application/vnd.github+json"
  client.auto_paginate = true
  usernames = csv_to_hash("#{__dir__}/../data/users.csv")
  commits = client.list_commits("#{repo}")
  puts "\nwrite commits to csv"
  already_exists = File.exist?("#{__dir__}/../data/contributions.csv")
  CSV.open("data/contributions.csv", 'a') do |csv|

    csv << ['Type', 'Created At', 'User', 'Repository', 'URL'] unless already_exists

    commits.each do |commit|
      username = commit.commit.committer.name
      if usernames.key?(commit.commit.committer.name.to_sym)
        username = usernames[commit.commit.committer.name.to_sym]
      end
      csv << ["COMMIT", commit.commit.author.date, username, repo, commit.html_url]
    end
  end
end
