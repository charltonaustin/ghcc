require 'date'
require 'csv'
start_date = Date.today - 14
end_date = Date.today
def csv_to_hash(file_name)
  usernames = {}
  CSV.foreach(file_name, headers: true) do |row|
    usernames[row[0].strip.to_sym] = row[1].strip
  end
  usernames
end

names_to_usernames = csv_to_hash('data/users.csv')
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


