# frozen_string_literal: true
require "thor"
require_relative 'user_details'
class Contributions < Thor

  desc "details", "Get details for a user"
  method_option :username, aliases: "u",
                :type => :string,
                :desc => "User name of the user"
  method_option :name, aliases: "n",
                :type => :string,
                :desc => "Name of the user"
  method_option :start_date,
                :type => :string, default: "#{Date.today - 14}",
                :desc => "First date to start counting contributions"
  method_option :end_date,
                :type => :string,
                default: "#{Date.today + 1}",
                :desc => "Last date to count contributions"
  method_option :ignore_reviews, aliases: "i",
                :type => :boolean,
                default: false,
                :desc => "Ignore review contributions"
  def details
    logger = get_logger
    username = options[:username]
    name = options[:name]
    ignore_reviews = options[:ignore_reviews]
    start_date = Date.parse(options[:start_date])
    end_date = Date.parse(options[:end_date])
    get_connection do |db|
      logger.debug("got connection running user_details")
      user_details(db, logger, start_date, end_date, username, name, ignore_reviews)
    end
  end

  desc "all", "Get contributions from user(s)"
  method_option :start_date,
                :type => :string, default: "#{Date.today - 14}",
                :desc => "First date to start counting contributions"
  method_option :end_date,
                :type => :string,
                default: "#{Date.today + 1}",
                :desc => "Last date to count contributions"
  method_option :ignore_reviews, aliases: "i",
                :type => :boolean,
                default: false,
                :desc => "Ignore review contributions"
  def all
    start_date = Date.parse(options[:start_date])
    end_date = Date.parse(options[:end_date])
    ignore_reviews = options[:ignore_reviews]
    
    get_connection do |db|
      display_contributions(db, start_date, end_date, ignore_reviews)
    end
  end
end
