# frozen_string_literal: true

require_relative 'refresh'
module Reviews
  class Command < Thor
    desc 'refresh', 'Refresh reviews'
    method_option :start_date,
                  type: :string, default: (Date.today - 14).to_s,
                  desc: 'First date to start counting contributions'
    method_option :end_date,
                  type: :string,
                  default: Date.today.to_s,
                  desc: 'Last date to count contributions'

    def refresh
      logger = get_logger(parent_options)
      start_date = Date.parse(options[:start_date])
      end_date = Date.parse(options[:end_date])
      client = git_client
      get_connection do |db|
        Reviews.refresh(db, client, logger, start_date, end_date)
      end
    end
  end
end
