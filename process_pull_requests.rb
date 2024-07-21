require 'date'
require 'csv'
start_date = Date.today - 14
end_date = Date.today
names_to_usernames = {
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
  "Jay Jayabose": "jayjayabose",
  "Gary Cuga-Moylan": "gecugamo",
  "Joshua Crawford": "joshuacrawford-kin",
  "Alex Berry": "alex-berry-kin",
  "Mario Saraiva": "mariosaraiva",
  "Charlton Austin": "charltonaustin",
  "Ken Hebel": "hebelken-kin"
}
usernames_to_names = names_to_usernames.invert

def read_data_from_csv(file_path)
  csv_content = CSV.open(file_path, headers: true, header_converters: :symbol)
  csv_content.to_a.map(&:to_hash)
end

pull_requests = read_data_from_csv("./data/contributions.csv")

def filter_by(end_date, pull_requests, start_date, username)
  pull_requests.select do |pull_request|
    all_true = []
    all_true << (Date.parse(pull_request[:created_at]) >= start_date) unless start_date.nil? || pull_request[:created_at] == "Created At"
    all_true << (Date.parse(pull_request[:created_at]) <= end_date) unless end_date.nil? || pull_request[:created_at] == "Created At"
    all_true << (pull_request[:user] == username) unless username.empty? || username.nil?
    all_true.all?
  end
end

user_pull_requests = {}
usernames_to_names.keys.each do |username|
  user_pull_requests[username] = filter_by(end_date, pull_requests, start_date, username)
end

user_pull_requests = user_pull_requests.sort_by do |username, prs|
  prs.size
end

def print_results(user_pull_requests, usernames)
  user_pull_requests.each do |username, contributions|

    commits = contributions.select { |record| record[:type] == "COMMIT" }
    prs = contributions.select { |record| record[:type] == "PR" }
    puts "#{usernames[username]}: #{contributions.size}, commits: #{commits.size}, prs: #{prs.size}"
  end

end

print_results(user_pull_requests, usernames_to_names)


