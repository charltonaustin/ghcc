def get_contributions_from_db(db, start_date, end_date, user_name, map ={})
  map = get_reviews_from_db(db, start_date, end_date, user_name, map)
  map = get_commits_from_db(db, start_date, end_date, user_name, map)
  map = get_pull_requests_from_db(db, start_date, end_date, user_name, map)
  map
end

def get_reviews_from_db(db, start_date, end_date, user_name, map)
  reviews = db["SELECT * FROM reviews WHERE user = ? AND creation BETWEEN ? AND ?",
               user_name, start_date, end_date].all
  map[:reviews] = reviews
  map
end

def get_commits_from_db(db, start_date, end_date, user_name, map)
  commits = db["SELECT * FROM commits WHERE user_name = ? AND creation BETWEEN ? AND ?",
               user_name, start_date, end_date].all
  map[:commits] = commits
  map
end

def get_pull_requests_from_db(db, start_date, end_date, user_name, map)
  pull_requests = db["SELECT * FROM pull_requests " +
                       "WHERE user_name = ? AND pr_creation BETWEEN ? AND ?",
                     user_name, start_date, end_date].all
  map[:pull_requests] = pull_requests
  map
end