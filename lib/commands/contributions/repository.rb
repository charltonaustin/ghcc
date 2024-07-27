def get_contributions_from_db(db, start_date, end_date, user_name)
  pull_requests = db["SELECT * FROM pull_requests " +
                       "WHERE user_name = ? AND pr_creation BETWEEN ? AND ?",
                     user_name, start_date, end_date].all

  commits = db["SELECT * FROM commits WHERE user_name = ? AND creation BETWEEN ? AND ?",
               user_name, start_date, end_date].all
  reviews = db["SELECT * FROM reviews WHERE user = ? AND creation BETWEEN ? AND ?",
               user_name, start_date, end_date].all
  { commits: commits, pull_requests: pull_requests, reviews: reviews }
end