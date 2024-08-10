# frozen_string_literal: true

require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'

def call_toggle_twice(db)
  toggle_by_username(db, double('logger').as_null_object, 'user_name')
  toggle_by_username(db, double('logger').as_null_object, 'user_name')
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
      save_user_name(db, 'user_name', 'name')
      save_user_name(db, 'user_name', 'name')
      expect(get_users(db).size).to eq(1)
    end
  end

  it 'toggles a user to false' do
    get_connection(db_name) do |db|
      save_user_name(db, 'user_name', 'name')
      toggle_by_username(db, double('logger').as_null_object, 'user_name')
      expect(get_users(db)[0][:to_process]).to be(true)
    end
  end

  it 'toggles a user to true' do
    get_connection(db_name) do |db|
      save_user_name(db, 'user_name', 'name')
      call_toggle_twice(db)
      expect(get_users(db)[0][:to_process]).to be(false)
    end
  end
end
