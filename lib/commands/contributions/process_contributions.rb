require 'date'
require 'csv'
require_relative 'repository'
require_relative '../repository'

def print_results(user_contributions)
  user_contributions.each do |_, data|
    commits = data[0][:commits]
    prs = data[0][:pull_requests]
    reviews = data[0][:reviews]
    name = data[1][:name]
    if name.nil?
      name = data[1][:user_name]
    end
    puts "#{name}: total: #{commits.size + prs.size + reviews.size}, "+
           "commits: #{commits.size}, prs: #{prs.size}. reviews: #{reviews.size}"
  end

end
def get_contributions(db, start_date, end_date)
  puts "start_date: #{start_date}, end_date: #{end_date}"
  user_contributions = {}
  users = get_users_to_process(db)
  users.each do |user|
    pull_requests = get_contributions_from_db(db, start_date, end_date, user[:user_name])
    user_contributions[user[:user_name]] = [pull_requests, user]
  end

  user_contributions = user_contributions.sort_by do |_, data|
    data[0][:commits].size + data[0][:pull_requests].size + data[0][:reviews].size
  end
  print_results(user_contributions)
end



