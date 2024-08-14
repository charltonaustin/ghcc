# frozen_string_literal: true

require 'thor'
require_relative 'user_details'
module Contributions
  class Command < Thor
    desc 'details', 'Get details for a user'
    method_option :username, aliases: 'u',
                             type: :string,
                             desc: 'User name of the user'
    method_option :name, aliases: 'n',
                         type: :string,
                         desc: 'Name of the user'
    method_option :start_date,
                  type: :string, default: (Date.today - 14).to_s,
                  desc: 'First date to start counting contributions'
    method_option :end_date,
                  type: :string,
                  default: (Date.today + 1).to_s,
                  desc: 'Last date to count contributions'
    method_option :ignore_reviews, aliases: 'i',
                                   type: :boolean,
                                   default: false,
                                   desc: 'Ignore review contributions'

    def details
      end_date, ignore_reviews, name, start_date, username = options_for_details(options)
      get_connection do |db|
        logger = get_logger(parent_options)
        logger.debug('got connection running user_details')
        user_details(db, logger, start_date, end_date, username, name, ignore_reviews)
      end
    end

    desc 'all', 'Get contributions from user(s)'
    method_option :start_date,
                  type: :string, default: (Date.today - 14).to_s,
                  desc: 'First date to start counting contributions'
    method_option :end_date,
                  type: :string,
                  default: (Date.today + 1).to_s,
                  desc: 'Last date to count contributions'
    method_option :ignore_reviews, aliases: 'i',
                                   type: :boolean,
                                   default: false,
                                   desc: 'Ignore review contributions'

    def all
      logger = get_logger(parent_options)
      start_date = Date.parse(options[:start_date])
      end_date = Date.parse(options[:end_date])
      ignore_reviews = options[:ignore_reviews]

      get_connection do |db|
        display_contributions(db, logger, start_date, end_date, ignore_reviews)
      end
    end
  end
end
