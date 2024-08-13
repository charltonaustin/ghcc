# frozen_string_literal: true

def get_users_to_process(db)
  db['SELECT * FROM users WHERE to_process = true'].all
end

def get_pull_requests_for_reviews(db, start_date, end_date)
  db['SELECT * FROM pull_requests ' \
     'WHERE pr_creation BETWEEN ? AND ?',
     start_date, end_date].all
end

def get_repos_to_process(db)
  db['SELECT * FROM repos WHERE to_process = true'].all
end

def get_orgs(db)
  db['SELECT * FROM orgs WHERE to_process = true'].all
end

def get_user_name(db, name)
  ds = db['select user_name from users where name = ?', name]
  ds.first[:user_name] unless ds.empty?
end
