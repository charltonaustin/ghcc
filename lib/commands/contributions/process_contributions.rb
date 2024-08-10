# frozen_string_literal: true

require 'date'
require 'csv'
require_relative 'repository'
require_relative '../repository'

def reviews(ignore_reviews, reviews)
  review_string = " reviews: #{reviews.size},"
  size = reviews.size
  if ignore_reviews
    review_string = ''
    size = 0
  end
  [review_string, size]
end

def names(data)
  commits = data[0][:commits]
  prs = data[0][:pull_requests]
  reviews = data[0][:reviews]
  name = data[1][:name]
  name = data[1][:user_name] if name.nil?
  [commits, name, prs, reviews]
end

def print_results(start_date, end_date, user_contributions, ignore_reviews)
  puts "start_date: #{start_date}, end_date: #{end_date}"
  user_contributions.each_value do |data|
    commits, name, prs, reviews = names(data)
    review_string, size = reviews(ignore_reviews, reviews)
    puts "#{name}: total: #{commits.size + prs.size + size}, " +
         review_string + " commits: #{commits.size}, prs: #{prs.size}"
  end
end

def review_values(data, ignore_reviews)
  review_size = data[0][:reviews].size
  review_size = 0 if ignore_reviews
  data[0][:commits].size + data[0][:pull_requests].size + review_size
end

def pr_values(db, end_date, start_date, user_contributions, users)
  users.each do |user|
    pull_requests = add_contributions(db, start_date, end_date, user[:user_name])
    user_contributions[user[:user_name]] = [pull_requests, user]
  end
end

def display_contributions(db, start_date, end_date, ignore_reviews)
  user_contributions = {}
  users = get_users_to_process(db)
  pr_values(db, end_date, start_date, user_contributions, users)

  user_contributions = user_contributions.sort_by do |_, data|
    review_values(data, ignore_reviews)
  end
  print_results(start_date, end_date, user_contributions, ignore_reviews)
end
