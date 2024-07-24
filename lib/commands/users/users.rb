# frozen_string_literal: true
require "thor"
require_relative 'list'
require_relative 'refresh'
require_relative 'toggle'

class Users < Thor
  desc "refresh", "Refresh users"
  method_option :org, aliases: "o", 
                :type => :string,
                default: "kin",
                :desc => "Name of the organization you want to get users for"
  def refresh
    logger = get_logger
    client = get_client
    org = options[:org]
    get_connection do |db|
      refresh_github_users(db, org, client, logger)
    end
  end

  desc "list", "List all users"
  method_option :search, aliases: "s",
                :type => :string,
                :desc => "A partial string to match against the user"
  method_option :to_process, aliases: "p",
                :type => :boolean,
                :default => false,
                :desc => "Only return users that are processed"
  def list
    search = options[:search]
    to_process = options[:to_process]
    get_connection do |db|
      list_from(db, search, to_process)
    end
  end

  desc "toggle", "Toggle to_process on a user"
  method_option :username, aliases: "un",
                :type => :string,
                :desc => "User name of the user"
  method_option :name, aliases: "n",
                :type => :string,
                :desc => "Name of the user"
  def toggle
    logger = get_logger
    username = options[:username]
    name = options[:name]
    get_connection do |db|
      logger.debug("got connection running toggle_user")
      toggle_user(db, logger, username, name)
    end
  end
end
