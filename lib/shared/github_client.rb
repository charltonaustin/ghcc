# frozen_string_literal: true

require 'octokit'
ACCESS_TOKEN = ENV.fetch('GHCC_ACCESS_TOKEN', nil)

def git_client
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)
  client.default_media_type = 'application/vnd.github+json'
  client.auto_paginate = true
  client
end
