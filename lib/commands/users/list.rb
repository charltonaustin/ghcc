# frozen_string_literal: true

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

def get_processable_users(users)
  users.select do |user|
    user[:to_process]
  end
end

def no_match(match)
  match.nil? || match.empty?
end

def match_name(jarow, match, users)
  users.select do |user|
    user[:name].nil? || matches(jarow, match, user[:name].downcase)
  end
end

def match_username(jarow, match, users)
  users.select do |user|
    user[:user_name].nil? || matches(jarow, match, user[:user_name].downcase)
  end
end

def list_users_from(db, match, to_process)
  users = get_users(db)
  users = get_processable_users(users) if to_process
  if no_match(match)
    print(users)
    return
  end

  string_matcher = FuzzyStringMatch::JaroWinkler.create(:pure)
  users = match_name(string_matcher, match, users)
  users = match_username(string_matcher, match, users)
  print(users)
end
