require 'rspec'
require_relative 'refresh'

RSpec.describe 'refresh_github_users' do
  it 'dumb test for exploration' do
    allow(self).to receive(:save_user_name)

    refresh_github_users(
      double("db"), 
      "org name", 
      double("client", org_members: [double("user").as_null_object]).as_null_object, 
      double("logger").as_null_object)

    expect(self).to have_received(:save_user_name)
  end
end