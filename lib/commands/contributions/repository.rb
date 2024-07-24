def get_contributions_from_db(db, start_date, end_date, user_name)
  pull_requests = db["SELECT * FROM pull_requests " +
                       "WHERE user_name = ? AND pr_creation BETWEEN ? AND ?",
                     user_name, start_date, end_date].all

  commits = db["SELECT * FROM commits WHERE user_name = ? AND creation BETWEEN ? AND ?",
               user_name, start_date, end_date].all
  { commits: commits, pull_requests: pull_requests }
end

def get_users_to_process(db)
  db["SELECT * FROM users WHERE to_process = true"].all
end