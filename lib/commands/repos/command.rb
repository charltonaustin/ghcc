# frozen_string_literal: true

require 'thor'
require_relative 'list'
require_relative 'add'
require_relative 'toggle'
module Repos
  class Command < Thor
    desc 'list', 'List all repos'

    def list
      get_connection do |db|
        list_repos(db)
      end
    end

    method_option :name, aliases: 'n',
                         type: :string,
                         required: true,
                         desc: 'Name of the repository to add'
    method_option :org, aliases: 'o',
                        type: :string,
                        required: true,
                        desc: 'Owner of the repository to add'
    desc 'add', 'Add a repo'

    def add
      name = options[:name]
      org = options[:org]
      get_connection do |db|
        add_repo(db, org, name)
      end
    end

    method_option :name, aliases: 'n',
                         type: :string,
                         required: true,
                         desc: 'Name of the repository to add'
    method_option :org, aliases: 'o',
                        type: :string,
                        required: true,
                        desc: 'Owner of the repository to add'
    desc 'toggle', 'Toggle whether or not to use the repo in processing'

    def toggle
      name = options[:name]
      org = options[:org]
      logger = get_logger(parent_options)
      get_connection do |db|
        toggle_repo(db, logger, org, name)
      end
    end
  end
end
