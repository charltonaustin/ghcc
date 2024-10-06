# frozen_string_literal: true

require 'rspec'
require 'Date'
require 'octokit'
require_relative 'refresh'

def setup
  allow(Reviews).to receive(:insert)
  allow(Reviews).to receive_messages(get_pull_requests_for_reviews: [{ repository: 'repo', number: 1 }],
                                     check_for: false)
  record = { user: { login: 1 }, html_url: 'test_url', submitted_at: 'submitted_at' }
  n = rand(100)
  client = double('client', pull_request_reviews: Array.new(n) { |_| record })
  [n, client]
end

def setup_multiple_users
  allow(Users::Repository).to receive(:save_user_name)
  n = rand(100)
  client = double('client', org_members: Array.new(n) { |_| double('user').as_null_object }).as_null_object
  [client, n]
end

def given_the_client_throws_an_exception
  client = double('client')
  allow(client).to receive(:pull_request_reviews).and_raise(Octokit::NotFound)
  logger = double('logger')
  allow(Reviews).to receive_messages(get_pull_requests_for_reviews: [{ repository: 'repo', number: 1 }],
                                     check_for: false)
  [client, logger]
end

RSpec.describe 'refresh' do
  it 'saves as many time as reviews are returned' do
    n, client = setup
    Reviews.refresh(double('db'), client, double('logger').as_null_object, Date.today.to_s,
                    (Date.today - 14).to_s)
    expect(Reviews).to have_received(:insert).exactly(n).times
  end

  it 'logs exception on error' do
    client, logger = given_the_client_throws_an_exception
    Reviews.refresh(double('db').as_null_object, client, logger.as_null_object, Date.today.to_s,
                    (Date.today - 14).to_s)
    expect(logger).to have_received(:error)
  end
end
