require 'octokit'

def get_github_org_members(org_name, access_token)
  client = Octokit::Client.new(access_token: access_token)
  members = client.org_members(org_name)
  

  members.each do |member|
    user = client.user(user=member.login)
    puts "User: #{member.fields}"
    puts "Name: #{user.fields}"
    puts "--------------------------------"
    break
  end
end

ACCESS_TOKEN = ENV['ACCESS_TOKEN']
get_github_org_members('kin', ACCESS_TOKEN)