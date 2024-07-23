require 'octokit'
ACCESS_TOKEN = ENV['GHCC_ACCESS_TOKEN']

def get_client
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)
  client.default_media_type = "application/vnd.github+json"
  client.auto_paginate = true
  client
end