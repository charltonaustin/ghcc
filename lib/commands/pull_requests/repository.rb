def get_latest_pull_requests(db)
    ds = db["SELECT number FROM pull_requests ORDER BY pr_creation DESC LIMIT 1"]
    ds.first unless ds.empty?
end

def has_saved_pull_request?(db, repo)
    ds = db["SELECT count(*) as c FROM pull_requests WHERE repository = ?", repo]
    ds.first[:c] > 0
end

def save_pull_request(db, created_at, user_name, url, repo, number)
    db[
      "INSERT INTO pull_requests (pr_creation, user_name,url, repository, number) VALUES (?, ?, ?, ?, ? )",
      created_at, user_name, url, repo, number
    ].insert
end

def get_repos_to_refresh(db)
    db["SELECT * FROM repos WHERE to_process = ?", true].all
end