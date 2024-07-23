require_relative '../../shared/database'
def get_latest
  get_connection do |db|
    ds = db["SELECT number FROM pull_requests ORDER BY pr_creation DESC LIMIT 1"]
    ds.first unless ds.empty?
  end
end

def has_saved?(repo)
  get_connection do |db|
    ds = db["SELECT count(*) as c FROM pull_requests WHERE repository = ?", repo]
    ds.first[:c] > 0
  end
end

def save(created_at, user_name, url, repo, number)
  get_connection do |db|
    db[
      "INSERT INTO pull_requests (pr_creation, user_name,url, repository, number) VALUES (?, ?, ?, ?, ? )",
      created_at, user_name, url, repo, number
    ].insert
  end
end