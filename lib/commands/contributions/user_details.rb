require_relative 'repository'

def print_details(logger, start_date, end_date, user_contributions, ignore_reviews)
  # logger.debug("user_contributions: #{user_contributions}")
  puts "start_date: #{start_date}, end_date: #{end_date}"
  commits = user_contributions[:commits]
  commit_urls = commits.map { |c| "#{c[:url]}, #{c[:creation].strftime('%Y-%m-%d')}" }
  prs = user_contributions[:pull_requests]
  prs_urls = prs.map { |p| "#{p[:url]}, #{p[:pr_creation].strftime('%Y-%m-%d')}" }
  reviews = user_contributions[:reviews]
  reviews_urls = reviews.map { |r| "#{r[:url]}, #{r[:creation].strftime('%Y-%m-%d')}" }
  name = user_contributions[:name]
  if name.nil?
    name = user_contributions[:user_name]
  end
  review_string = "\nreviews: #{reviews.size}\n#{reviews_urls.join("\n")}"
  if ignore_reviews
    review_string = ""
  end
  
  puts "#{name}\ntotal: #{commits.size + prs.size + reviews.size}" +
         review_string +
         "\ncommits: #{commits.size}\n#{commit_urls.join("\n")}" +
         "\nprs: #{prs.size}\n#{prs_urls.join("\n")}"
end

def get_contributions_name(db, logger, start_date, end_date, name)
  logger.debug("QUERY IS: SELECT user_name FROM users WHERE name = '#{name}'")
  ds = db["SELECT user_name FROM users WHERE name = '#{name}'"]
  logger.debug("ds.empty?: #{ds.empty?}")
  logger.debug("ds.first[:user_name]: #{ds.first[:user_name]}")
  uname = ds.first[:user_name] unless ds.empty?
  logger.debug("uname: #{uname}")
  contributions = get_contributions_uname(db, logger, start_date, end_date, uname)
  contributions[:name] = name
  contributions
end

def get_contributions_uname(db, logger, start_date, end_date, uname)
  contributions = add_contributions(db, start_date, end_date, uname)
  contributions[:user_name] = uname
  contributions
end

def user_details(db, logger, start_date, end_date, uname, name, ignore_reviews)
  unless uname.nil?
    user_contributions = get_contributions_uname(db, logger, start_date, end_date, uname)
  end
  unless name.nil?
    user_contributions = get_contributions_name(db, logger, start_date, end_date, name)
  end
  
  

  unless user_contributions.nil?
    print_details(logger, start_date, end_date, user_contributions, ignore_reviews)
  end
end