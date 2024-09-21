# frozen_string_literal: true

require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'

def call_toggle_twice(db)
  Users::Repository.toggle_by_username(db, double('logger').as_null_object, 'user_name')
  Users::Repository.toggle_by_username(db, double('logger').as_null_object, 'user_name')
end

def call_toggle_by_name_twice(db)
  Users::Repository.toggle_by_name(db, double('logger').as_null_object, 'name')
  Users::Repository.toggle_by_name(db, double('logger').as_null_object, 'name')
end

RSpec.describe 'users/repository', type: 'database' do
  let(:db_name) do
    uuid = SecureRandom.uuid
    "test-#{uuid}.db"
  end

  before do
    get_connection(db_name) do |db|
      Sequel.extension :migration
      Sequel::Migrator.run(db, File.expand_path("#{__dir__}/../../migrations"))
    end
  end

  after do
    delete_database(db_name)
  end

  it 'saves a user in an idempotent way' do
    get_connection(db_name) do |db|
      Users::Repository.save_user_name(db, 'user_name', 'name')
      Users::Repository.save_user_name(db, 'user_name', 'name')
      expect(Users::Repository.get_users(db).size).to eq(1)
    end
  end

  it 'toggles a user to false' do
    get_connection(db_name) do |db|
      Users::Repository.save_user_name(db, 'user_name', 'name')
      Users::Repository.toggle_by_username(db, double('logger').as_null_object, 'user_name')
      expect(Users::Repository.get_users(db)[0][:to_process]).to be(true)
    end
  end

  it 'toggles a user by username to true' do
    get_connection(db_name) do |db|
      Users::Repository.save_user_name(db, 'user_name', 'name')
      call_toggle_twice(db)
      expect(Users::Repository.get_users(db)[0][:to_process]).to be(false)
    end
  end

  it 'toggles a user by name to true' do
    get_connection(db_name) do |db|
      Users::Repository.save_user_name(db, 'user_name', 'name')
      call_toggle_by_name_twice(db)
      expect(Users::Repository.get_users(db)[0][:to_process]).to be(false)
    end
  end
end
