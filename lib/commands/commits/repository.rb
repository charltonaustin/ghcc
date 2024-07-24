def save_commit(db, creation, user_name, repository, url)
  return if db["SELECT count(*) as c FROM commits WHERE url = ?", url].first[:c] > 0
  db["INSERT into commits (creation, user_name, repository, url) VALUES (?, ?, ?, ?)",
     creation, user_name, repository, url].insert
end

def get_user_name(db, name)
  ds = db["select user_name from users where name = ?", name]
  ds.first[:user_name] unless ds.empty?
end