# frozen_string_literal: true

require_relative 'repository'

def format_commits(user_contributions)
  user_contributions[:commits].map { |c| "#{c[:url]}, #{c[:creation].strftime('%Y-%m-%d')}" }
end

def format_prs(user_contributions)
  user_contributions[:pull_requests].map { |p| "#{p[:url]}, #{p[:pr_creation].strftime('%Y-%m-%d')}" }
end

def format_reviews(user_contributions)
  user_contributions[:reviews].map { |r| "#{r[:url]}, #{r[:creation].strftime('%Y-%m-%d')}" }
end

def map_contributions(user_contributions)
  commit_urls = format_commits(user_contributions)
  prs_urls = format_prs(user_contributions)
  reviews_urls = format_reviews(user_contributions)
  [commit_urls, prs_urls, reviews_urls]
end

def name(user_contributions)
  name = user_contributions[:name]
  name = user_contributions[:user_name] if name.nil?
  name
end

def log_details(end_date, logger, start_date, user_contributions)
  logger.debug("user_contributions: #{user_contributions}")
  logger.debug("start_date: #{start_date}, end_date: #{end_date}")
end

def calculate_review_string(ignore_reviews, reviews, reviews_urls)
  review_string = "\nreviews: #{reviews.size}\n#{reviews_urls.join("\n")}"
  review_string = '' if ignore_reviews
  review_string
end

def print_string_for(name, contributions)
  "\n#{name}: #{contributions.size}\n#{contributions.join("\n")}"
end

def calculate(ignore_reviews, user_contributions)
  commit_urls, prs_urls, reviews_urls = map_contributions(user_contributions)
  name = name(user_contributions)
  review_string = calculate_review_string(ignore_reviews, reviews_urls)
  [commit_urls, name, prs_urls, review_string]
end

def print_details(logger, start_date, end_date, user_contributions, ignore_reviews)
  log_details(end_date, logger, start_date, user_contributions)
  commit_urls, name, prs_urls, review_string = calculate(ignore_reviews, user_contributions)

  puts "#{name}\ntotal: #{commits.size + prs.size + reviews.size}" + review_string +
       print_string_for('commits', commit_urls) +
       print_string_for('prs', prs_urls)
end

def get_contributions_name(db, logger, start_date, end_date, name)
  logger.debug("QUERY IS: SELECT user_name FROM users WHERE name = '#{name}'")
  ds = db['SELECT user_name FROM users WHERE name = ?', name]
  logger.debug("ds.empty?: #{ds.empty?}")
  logger.debug("ds.first[:user_name]: #{ds.first[:user_name]}")
  uname = ds.first[:user_name] unless ds.empty?
  logger.debug("uname: #{uname}")
  contributions = get_contributions_uname(db, logger, start_date, end_date, uname)
  contributions[:name] = name
  contributions
end

def get_contributions_uname(db, _logger, start_date, end_date, uname)
  contributions = add_contributions(db, start_date, end_date, uname)
  contributions[:user_name] = uname
  contributions
end

def user_details(db, logger, start_date, end_date, uname, name, ignore_reviews)
  user_contributions = get_contributions_uname(db, logger, start_date, end_date, uname) unless uname.nil?
  user_contributions = get_contributions_name(db, logger, start_date, end_date, name) unless name.nil?

  return if user_contributions.nil?

  print_details(logger, start_date, end_date, user_contributions, ignore_reviews)
end
