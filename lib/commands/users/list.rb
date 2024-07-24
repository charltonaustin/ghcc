require_relative 'repository'
require 'fuzzystringmatch'

def print(users)
  users.each do |user|
    puts "Username: #{user[:user_name]}, name: #{user[:name]}, to_process: #{user[:to_process]} "
  end
end

def matches(jarow, match, value)
  name_match = jarow.getDistance(value, match)
  name_match && (name_match > 0.7)
end

def list_from(db, match, to_process)
  users = get_users(db)
  if to_process
    users = users.select do |user|
      user[:to_process]
    end
  end
  if match.nil? || match.empty?
    print(users)
    return
  end
  
  jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
  users = users.select do |user|
    user[:name].nil? || matches(jarow, match, user[:name].downcase)
  end
  users = users.select do |user|
    user[:user_name].nil? || matches(jarow, match, user[:user_name].downcase)
  end
  print(users)
end