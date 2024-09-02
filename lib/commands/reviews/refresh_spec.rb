# frozen_string_literal: true

require 'rspec'
require 'Date'
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

RSpec.describe 'refresh' do
  it 'saves as many time as reviews are returned' do
    n, client = setup
    Reviews.refresh(double('db'), client, double('logger').as_null_object, Date.today.to_s,
                    (Date.today - 14).to_s)
    expect(Reviews).to have_received(:insert).exactly(n).times
  end
end
