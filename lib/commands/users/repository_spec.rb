require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'


RSpec.describe 'users/repository', :type => 'database' do
  
  before(:each) do
    uuid = SecureRandom.uuid
    @db_name = "test-#{uuid}.db"
    delete_database(@db_name)
    get_connection(@db_name) do |db|
      Sequel.extension :migration
      Sequel::Migrator.run(db, File.expand_path("#{__dir__}/../../migrations"))
    end
  end
  
  after(:each) do
    delete_database(@db_name)
  end
  
  it 'should save a user in an idempotent way' do
    get_connection(@db_name) do |db|
      save_user_name(db, "user_name", "name")
      save_user_name(db, "user_name", "name")
      expect(get_users(db).size).to eq(1) 
    end
  end

  it 'should toggle a user' do
    get_connection(@db_name) do |db|
      save_user_name(db, "user_name", "name")
      toggle_by_username(db, double("logger").as_null_object, "user_name")
      expect(get_users(db)[0][:to_process]).to eq(true)
      toggle_by_username(db, double("logger").as_null_object, "user_name")
      expect(get_users(db)[0][:to_process]).to eq(false)
    end
  end
end