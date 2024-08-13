# frozen_string_literal: true

module ReviewsRepository
  def self.insert(db, repo)
    db['INSERT INTO reviews (creation, user, repository, url) VALUES (?, ?, ?, ?)',
       repo[:submitted_at], repo[:user], repo[:repository], repo[:html_url]].insert
  end

  def self.check_for(db, html_url)
    db['SELECT count(*) as c FROM reviews where url = ?', html_url].first[:c].positive?
  end
end
