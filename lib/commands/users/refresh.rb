require_relative '../../shared/github_client'
require_relative '../../shared/logger'
  
client = get_client
logger = get_logger
def get_github_org_members(org_name, client, logger)
  members = client.org_members(org_name)
  members.each do |member|
    user = client.user(user=member.login)
    logger.debug("User: #{member.login}")
    logger.debug("Name: #{user.name}")
    
  end
end

get_github_org_members('kin', client, logger)