# frozen_string_literal: true

require_relative 'repository'
module Users
  def self.toggle_user(db, logger, user_name, name)
    if user_name
      logger.debug("toggle user_name: #{user_name}")
      return Users::Repository.toggle_by_username(db, logger, user_name)
    end
    return unless name

    logger.debug("toggle name: #{name}")
    Users::Repository.toggle_by_name(db, logger, name)
  end
end
