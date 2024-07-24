# frozen_string_literal: true
require "thor"
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
end
