# frozen_string_literal: true

require 'thor'
require_relative 'list'
require_relative 'refresh'
require_relative 'toggle'
module Users
  class Command < Thor
    desc 'refresh', 'Refresh users with saved orgs'

    def refresh
      logger = get_logger(parent_options)
      client = git_client
      logger.debug('users refresh')
      get_connection do |db|
        orgs = get_orgs(db)
        orgs.each do |org|
          logger.debug("Getting users for org: #{org}")
          refresh_github_users(db, org[:name], client, logger)
        end
      end
    end

    desc 'list', 'List all users'
    method_option :search, aliases: 's',
                           type: :string,
                           desc: 'A partial string to match against the user'
    method_option :to_process, aliases: 'p',
                               type: :boolean,
                               default: false,
                               desc: 'Only return users that are processed'

    def list
      search = options[:search]
      to_process = options[:to_process]
      get_connection do |db|
        List.list_users_from(db, search, to_process)
      end
    end

    desc 'toggle', 'Toggle to_process on a user'
    method_option :username, aliases: 'u',
                             type: :string,
                             desc: 'User name of the user'
    method_option :name, aliases: 'n',
                         type: :string,
                         desc: 'Name of the user'

    def toggle
      logger = get_logger(parent_options)
      username = options[:username]
      name = options[:name]
      get_connection do |db|
        logger.debug('got connection running toggle_user')
        toggle_user(db, logger, username, name)
      end
    end
  end
end
