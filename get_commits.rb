require 'octokit'
require 'date'
require 'csv'

ACCESS_TOKEN = ENV['ACCESS_TOKEN']

usernames = {
  "Jonah Householder": "JonahHouseKin",
  "Christian Ruiz": "rueeazy",
  "Jose Elera": "jelera",
  "Hannah Stannard": "hannahrstannard",
  "Caleb Masters": "thecaleblee",
  "Victor Lee": "victorclee",
  "Michael Specter": "mspecter-kin",
  "Kyle Dayton": "kyledayton",
  "Arvin Randhawa": "arvin-kin",
  "Michael Nash": "utumno86",
  "Andrew Ferguson": "Drewfergusson",
  "Violet": "rvehall-kin",
  "Taylor Galloway": "tylrs",
  "Sundar Jayabose": "jayjayabose",
  "Gary Cuga-Moylan": "gecugamo",
  "Joshua Crawford": "joshuacrawford-kin",
  "Alex Berry": "alex-berry-kin",
}

client = Octokit::Client.new(access_token: ACCESS_TOKEN)
client.default_media_type = "application/vnd.github+json"
client.auto_paginate = false

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