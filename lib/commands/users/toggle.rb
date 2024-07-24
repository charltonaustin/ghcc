
def toggle_user(db, logger, user_name, name)
  if user_name
    logger.debug("toggle user_name: #{user_name}")
    toggle_by_username(db, logger, user_name)
  end
end