# frozen_string_literal: true

require 'rspec'
require_relative 'refresh'

def setup
  allow(self).to receive(:save_user_name)
  db = double('db')
  member = double('member', login: 'test_login').as_null_object
  user = double('user', name: 'test name')
  client = double('client', org_members: [member], user:).as_null_object
  [client, db]
end

def setup_multiple_users
  allow(self).to receive(:save_user_name)
  n = rand(100)
  clients = double('client', org_members: Array.new(n) { |_| double('user').as_null_object }).as_null_object
  [clients, n]
end

RSpec.describe 'refresh_github_users' do
  it 'refresh should save as many time as users are returned' do
    clients, n = setup_multiple_users
    refresh_github_users(double('db'), 'org name', clients, double('logger').as_null_object)
    expect(self).to have_received(:save_user_name).exactly(n).times
  end

  it 'refresh should be called with the correct parameters' do
    client, db = setup
    refresh_github_users(db, 'org name', client, double('logger').as_null_object)
    expect(self).to have_received(:save_user_name).with(db, 'test_login', 'test name')
  end
end
