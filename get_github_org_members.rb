require 'octokit'

def get_github_org_members(org_name, access_token)
  client = Octokit::Client.new(access_token: access_token)
  client.auto_paginate = true
  members = client.org_members(org_name, per_page: 100, page: 1)
  # puts members.fields

  members.each do |member|
    user = client.user(user=member.login)
    puts "User: #{member.login}"
    puts "Name: #{user.name}"
    puts "Email: #{user.email}"
    puts "--------------------------------"
  end
end

ACCESS_TOKEN = ENV['ACCESS_TOKEN']
get_github_org_members('kin', ACCESS_TOKEN)