# frozen_string_literal: true

require 'securerandom'
require 'rspec'
require_relative '../shared/database'
require_relative 'read_repository'

def insert_data(db)
  db["INSERT INTO users (user_name, name, to_process) VALUES ('test user name 1', 'test name to process', '1')"].insert
  db["INSERT INTO users (user_name, name, to_process) VALUES ('test user name 2', 'test name', '0')"].insert
end

RSpec.describe 'ReadRepository', type: 'database' do
  let(:db_name) do
    uuid = SecureRandom.uuid
    "test-#{uuid}.db"
  end

  before do
    get_connection(db_name) do |db|
      Sequel.extension :migration
      Sequel::Migrator.run(db, File.expand_path("#{__dir__}/../migrations"))
    end
  end

  after do
    delete_database(db_name)
  end

  context 'when get_pull_requests_for_reviews is called' do
    it 'returns all pull requests' do
      get_connection(db_name) do |db|
        expect(get_pull_requests_for_reviews(db, Date.today, Date.today - 14)).to eq([])
      end
    end
  end

  context 'when get_repos_to_process is called' do
    it 'returns all repos for processing' do
      get_connection(db_name) do |db|
        db["INSERT INTO repos (organization, name, to_process) VALUES ('test org name', 'test name', '1')"].insert
        db["INSERT INTO repos (organization, name, to_process) VALUES ('test org name', 'test name', '0')"].insert
        expect(get_repos_to_process(db).size).to eq(1)
      end
    end
  end

  context 'when get_orgs is called' do
    it 'returns all orgs for processing' do
      get_connection(db_name) do |db|
        db["INSERT INTO orgs (name, to_process) VALUES ('test org name', '1')"].insert
        db["INSERT INTO orgs (name, to_process) VALUES ('test org name', '0')"].insert
        expect(get_orgs(db).size).to eq(1)
      end
    end
  end

  context 'when get_users_to_process is called' do
    it 'returns all users for processing' do
      get_connection(db_name) do |db|
        insert_data(db)
        expect(get_users_to_process(db).size).to eq(1)
      end
    end
  end

  context 'when get_user_name is called' do
    it 'returns all users for processing' do
      get_connection(db_name) do |db|
        insert_data(db)
        db["INSERT INTO users (user_name, name, to_process) VALUES ('test', 'name test', '0')"].insert
        expect(get_user_name(db, 'name test')).to eq('test')
      end
    end
  end
end
