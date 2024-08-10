# frozen_string_literal: true

require_relative 'repository'

def refresh_github_users(db, org_name, client, logger)
  members = client.org_members(org_name)
  members.each do |member|
    user = client.user(member.login)
    logger.debug("User: #{member.login}")
    logger.debug("Name: #{user.name}")
    save_user_name(db, member.login, user.name)
  end
end
