# frozen_string_literal: true

require_relative 'repository'
module Users
  def self.refresh(db, org_name, client, logger)
    members = client.org_members(org_name)
    members.each do |member|
      user = client.user(member.login)
      logger.debug("User: #{member.login}")
      logger.debug("Name: #{user.name}")
      Users::Repository.save_user_name(db, member.login, user.name)
    end
  end
end
