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

def log_details(logger, date_range, user_contributions)
  logger.debug("user_contributions: #{user_contributions}")
  logger.debug("start_date: #{date_range[:start_date]}, end_date: #{date_range[:end_date]}")
end

def calculate_review_string(ignore_reviews, reviews_urls)
  review_string = "\nreviews: #{reviews_urls.size}\n#{reviews_urls.join("\n")}"
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
  [commit_urls, name, prs_urls, reviews_urls, review_string]
end

def print_details(logger, date_range, user_contributions, ignore_reviews)
  log_details(logger, date_range, user_contributions)
  commit_urls, name, prs_urls, review_urls, review_string = calculate(ignore_reviews, user_contributions)
  puts "#{name}\ntotal: #{commit_urls.size + prs_urls.size + review_urls.size}" + review_string +
       print_string_for('commits', commit_urls) +
       print_string_for('prs', prs_urls)
end

def get_contributions_name(db, logger, date_range, name)
  logger.debug("QUERY IS: SELECT user_name FROM users WHERE name = '#{name}'")
  ds = db['SELECT user_name FROM users WHERE name = ?', name]
  logger.debug("ds.empty?: #{ds.empty?}")
  uname = ds.first[:user_name] unless ds.empty?
  contributions = get_contributions_uname(db, logger, date_range, uname)
  contributions[:name] = name
  contributions
end

def get_contributions_uname(db, _logger, date_range, uname)
  contributions = add_contributions(db, date_range, uname)
  contributions[:user_name] = uname
  contributions
end

def user_details(app_context, date_range, uname, name, ignore_reviews)
  unless uname.nil?
    user_contributions = get_contributions_uname(app_context[:db], app_context[:logger], date_range,
                                                 uname)
  end
  user_contributions = get_contributions_name(app_context[:db], app_context[:logger], date_range, name) unless name.nil?

  return if user_contributions.nil?

  print_details(app_context[:logger], date_range, user_contributions, ignore_reviews)
end

def options_for_details(options)
  username = options[:username]
  name = options[:name]
  ignore_reviews = options[:ignore_reviews]
  start_date = Date.parse(options[:start_date])
  end_date = Date.parse(options[:end_date])
  [end_date, ignore_reviews, name, start_date, username]
end
