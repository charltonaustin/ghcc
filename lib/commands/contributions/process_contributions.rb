# frozen_string_literal: true

require 'date'
require 'csv'
require_relative 'repository'
require_relative '../read_repository'

def reviews(ignore_reviews, reviews)
  return ['', 0] if ignore_reviews

  [" reviews: #{reviews.size},", reviews.size]
end

def parse(data)
  commits = data[1][0][:commits]
  prs = data[1][0][:pull_requests]
  reviews = data[1][0][:reviews]
  name = data[1][1][:name]
  name = data[1][1][:user_name] if name.nil?
  [commits, name, prs, reviews]
end

def print_(date_range)
  puts "start_date: #{date_range[:start_date]}, end_date: #{date_range[:end_date]}"
end

def print_results(logger, date_range, user_contributions, ignore_reviews)
  print_(date_range)
  user_contributions.each do |data|
    logger.debug("data: #{data}")
    commits, name, prs, reviews = parse(data)
    review_string, size = reviews(ignore_reviews, reviews)
    puts "#{name}: total: #{commits.size + prs.size + size}, " +
         review_string + " commits: #{commits.size}, prs: #{prs.size}"
  end
end

def contribution_size(data, ignore_reviews)
  review_size = data[0][:reviews].size
  review_size = 0 if ignore_reviews
  data[0][:commits].size + data[0][:pull_requests].size + review_size
end

def pr_values(db, date_range, user_contributions, users)
  users.each do |user|
    pull_requests = add_contributions(db, date_range, user[:user_name])
    user_contributions[user[:user_name]] = [pull_requests, user]
  end
end

def display_contributions(db, logger, date_range, ignore_reviews)
  user_contributions = {}
  users = get_users_to_process(db)
  pr_values(db, date_range, user_contributions, users)

  user_contributions = user_contributions.sort_by do |_, data|
    contribution_size(data, ignore_reviews)
  end
  print_results(logger, date_range, user_contributions, ignore_reviews)
end
