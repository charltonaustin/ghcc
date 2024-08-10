# frozen_string_literal: true

def save_commit(db, creation, user_name, repository, url)
  return if db['SELECT count(*) as c FROM commits WHERE url = ?', url].first[:c].positive?

  db['INSERT into commits (creation, user_name, repository, url) VALUES (?, ?, ?, ?)',
     creation, user_name, repository, url].insert
end
