require_relative '../repository'

def get_reviews(client, pull_request)
  (client.pull_request_reviews(pull_request[:repository], pull_request[:number])).map { 
    |r|  { repository: pull_request[:repository], user: r[:user][:login], html_url: r[:html_url], submitted_at: r[:submitted_at]} 
  }
end
def save_review(db, review)
  review.each do |r|
    puts "review: #{r}"
    next if db["SELECT count(*) as c FROM reviews where url = ?", r[:html_url]].first[:c] > 0
    db["INSERT INTO reviews (creation, user, repository, url) VALUES (?, ?, ?, ?)",
       r[:submitted_at], r[:user], r[:repository], r[:html_url]].insert
  end
end
def refresh_reviews(db, client, start_date, end_date)
  pull_requests = get_pull_requests_for_reviews(db, start_date, end_date)
  reviews = []
  pull_requests.each do |pull_request|
    puts "pull_request: #{pull_request}"
    reviews << get_reviews(client, pull_request)
  end
  reviews.each do | review |
    save_review(db, review)
  end
end