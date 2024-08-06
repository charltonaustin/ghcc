require 'rspec'
require_relative 'refresh'

RSpec.describe 'refresh_github_users' do
  it 'refresh should save as many time as users are returned' do
    allow(self).to receive(:save_user_name)
    n = rand(100)
    refresh_github_users(
      double("db"), 
      "org name",
      double("client", org_members: Array.new(n) { |_| double("user").as_null_object }).as_null_object,
      double("logger").as_null_object)

    expect(self).to have_received(:save_user_name).exactly(n).times
  end

  it 'refresh should be called with the correct parameters' do
    allow(self).to receive(:save_user_name)
    db = double("db")
    refresh_github_users(
      db,
      "org name",
      double("client", org_members: [double("member",
                                            :login => "test_login").as_null_object],
             user: double("user", name: "test name")).as_null_object,
      double("logger").as_null_object)

    expect(self).to have_received(:save_user_name).with(db,"test_login", "test name")
  end
end