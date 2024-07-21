require 'octokit'

def get_github_org_members(org_name, access_token)
  client = Octokit::Client.new(access_token: access_token)
  client.auto_paginate = true
  members = client.org_members(org_name)
  # puts members.fields

  members.each do |member|
    user = client.user(user=member.login)
    puts "User: #{member.login}"
    puts "Name: #{user.name}"
    puts "Email: #{user.email}"
    puts "--------------------------------"
  end
end

ACCESS_TOKEN = ENV['GHCC_ACCESS_TOKEN']
get_github_org_members('kin', ACCESS_TOKEN)