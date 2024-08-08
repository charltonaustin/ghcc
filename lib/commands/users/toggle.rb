require_relative 'repository'

def toggle_user(db, logger, user_name, name)
  if user_name
    logger.debug("toggle user_name: #{user_name}")
    return toggle_by_username(db, logger, user_name)
  end
  if name
    logger.debug("toggle name: #{name}")
    toggle_by_name(db, logger, name)
  end
end