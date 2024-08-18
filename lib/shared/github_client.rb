# frozen_string_literal: true

require 'octokit'
ACCESS_TOKEN = ENV.fetch('GHCC_ACCESS_TOKEN', nil)

def warn_missing_access_token
  puts 'MISSING ACCESS TOKEN SO COMMANDS WILL ONLY WORK ON PUBLIC REPOS'
end

def git_client
  warn_missing_access_token if ACCESS_TOKEN.nil?
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)
  client.default_media_type = 'application/vnd.github+json'
  client.auto_paginate = true
  client
end
