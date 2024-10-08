# frozen_string_literal: true

def add_contributions(db, date_range, user_name, map = {})
  map = add_reviews(db, date_range, user_name, map)
  map = add_commits(db, date_range, user_name, map)
  add_pull_requests(db, date_range, user_name, map)
end

def add_reviews(db, date_range, user_name, map)
  reviews = db['SELECT * FROM reviews WHERE user = ? AND creation BETWEEN ? AND ?',
               user_name, date_range[:start_date], date_range[:end_date]].all
  map[:reviews] = reviews
  map
end

def add_commits(db, date_range, user_name, map)
  commits = db['SELECT * FROM commits WHERE user_name = ? AND creation BETWEEN ? AND ?',
               user_name, date_range[:start_date], date_range[:end_date]].all
  map[:commits] = commits
  map
end

def add_pull_requests(db, date_range, user_name, map)
  pull_requests = db['SELECT * FROM pull_requests ' \
                     'WHERE user_name = ? AND pr_creation BETWEEN ? AND ?',
                     user_name, date_range[:start_date], date_range[:end_date]].all

  map[:pull_requests] = pull_requests
  map
end
