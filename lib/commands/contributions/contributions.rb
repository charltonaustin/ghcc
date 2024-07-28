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
                default: "#{Date.today}",
                :desc => "Last date to count contributions"
  def details
    logger = get_logger
    username = options[:username]
    name = options[:name]
    start_date = Date.parse(options[:start_date])
    end_date = Date.parse(options[:end_date])
    get_connection do |db|
      logger.debug("got connection running user_details")
      user_details(db, logger, start_date, end_date, username, name)
    end
  end

  desc "all", "Get contributions from user(s)"
  method_option :start_date,
                :type => :string, default: "#{Date.today - 14}",
                :desc => "First date to start counting contributions"
  method_option :end_date,
                :type => :string,
                default: "#{Date.today}",
                :desc => "Last date to count contributions"
  def all
    start_date = Date.parse(options[:start_date])
    end_date = Date.parse(options[:end_date])
    get_connection do |db|
      get_contributions(db, start_date, end_date)
    end
  end
end
