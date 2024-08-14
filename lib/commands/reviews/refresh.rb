# frozen_string_literal: true

require_relative '../read_repository'
require_relative 'repository'
module Reviews
  def self.refresh(db, client, logger, start_date, end_date)
    pull_requests = get_pull_requests_for_reviews(db, start_date, end_date)
    reviews = []
    pull_requests.each do |pull_request|
      logger.debug("pull_request: #{pull_request}")
      reviews << get_reviews(client, logger, pull_request)
    end
    reviews.each do |review|
      save_review(db, logger, review)
    end
  end

  private_class_method def self.get_reviews(client, logger, pull_request)
    logger.debug("pull_request[:repository]: #{pull_request[:repository]}")
    logger.debug("pull_request[:number]: #{pull_request[:number]}")
    begin
      client.pull_request_reviews(pull_request[:repository], pull_request[:number]).map do |r|
        { repository: pull_request[:repository], user: r[:user][:login], html_url: r[:html_url],
          submitted_at: r[:submitted_at] }
      end
    rescue Octokit::NotFound => e
      logger.error(e)
    end
  end

  private_class_method def self.save_review(db, logger, review)
    review.each do |r|
      logger.debug("review: #{r}")

      already_saved = ReviewsRepository.check_for(db, r[:html_url])
      logger.debug('review saved') if already_saved
      next if already_saved

      ReviewsRepository.insert(db, r)
    end
  end
end
