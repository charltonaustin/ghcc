def save_user_name(db, user_name, name)
  return if db["select count(*) as c from users where user_name = ?", user_name].first[:c] > 0
  db[
    "INSERT INTO users (user_name,name) VALUES (?, ?)",
    user_name, name
  ].insert
end

def get_users(db)
  db["SELECT * FROM users"].all
end