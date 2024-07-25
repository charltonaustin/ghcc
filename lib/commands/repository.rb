def get_users_to_process(db)
  db["SELECT * FROM users WHERE to_process = true"].all
end

def get_pull_requests_for_reviews(db, start_date, end_date, users, repos)
  
end