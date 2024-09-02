# frozen_string_literal: true

module Reviews
  def self.insert(db, repo)
    return if check_for(db, repo[:html_url])

    db['INSERT INTO reviews (creation, user, repository, url) VALUES (?, ?, ?, ?)',
       repo[:submitted_at], repo[:user], repo[:repository], repo[:html_url]].insert
  end

  def self.check_for(db, html_url)
    db['SELECT count(*) as c FROM reviews where url = ?', html_url].first[:c].positive?
  end
end
