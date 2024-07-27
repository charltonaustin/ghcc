def get_users_to_process(db)
  db["SELECT * FROM users WHERE to_process = true"].all
end

def get_pull_requests_for_reviews(db, start_date, end_date)
  db["SELECT * FROM pull_requests " +
       "WHERE pr_creation BETWEEN ? AND ?",
     start_date, end_date].all
end

def get_repos_to_process(db)
  db["SELECT * FROM repos WHERE to_process = true"].all
end