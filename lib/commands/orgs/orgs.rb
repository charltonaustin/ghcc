# frozen_string_literal: true

require 'thor'
require_relative 'add'

class Orgs < Thor
  desc 'add NAME', 'Add in a new org with the name NAME'

  def add(name)
    logger = get_logger
    get_connection do |db|
      logger.debug("Adding in org #{name}")
      save_org(db, logger, name)
    end
  end

  desc 'toggle NAME', 'Toggle to_process on org with name NAME'

  def toggle(name)
    puts "Toggle org #{name}"
  end
end
