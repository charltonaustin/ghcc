# frozen_string_literal: true

module PRS
  private_class_method def self.get_latest_pull_requests(db)
    ds = db['SELECT number FROM pull_requests ORDER BY pr_creation DESC LIMIT 1']
    ds.first unless ds.empty?
  end

  private_class_method def self.saved_pull_request?(db, repo)
    ds = db['SELECT count(*) as c FROM pull_requests WHERE repository = ?', repo]
    ds.first[:c].positive?
  end

  private_class_method def self.save_pull_request(db, created_at, user_name, url, repo, number)
    return unless db['SELECT * from pull_requests where url = ?', url].empty?

    db[
      'INSERT INTO pull_requests (pr_creation, user_name, url, repository, number) VALUES (?, ?, ?, ?, ? )',
      created_at, user_name, url, repo, number
    ].insert
  end
end
