# frozen_string_literal: true

require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'

# rubocop:disable Metrics/AbcSize
def check_expected(result)
  expect(result).not_to be_nil
  expect(result[:creation].to_date.to_s).to eq(creation)
  expect(result[:user_name]).to eq(user_name)
  expect(result[:repository]).to eq(repository)
  expect(result[:url]).to eq(url)
end
# rubocop:enable Metrics/AbcSize

def save_twice(db)
  save_commit(db, creation, user_name, repository, url)
  save_commit(db, creation, user_name, repository, url)
end

RSpec.describe 'repos/repository', type: 'database' do
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

  describe '#save_commit' do
    let(:creation) { '2024-09-12' }
    let(:user_name) { 'John Doe' }
    let(:repository) { 'example_repo' }
    let(:url) { 'http://example.com/commit' }

    it 'inserts the commit if it does not exist' do
      get_connection(db_name) do |db|
        save_commit(db, creation, user_name, repository, url)
        expect(db['SELECT * FROM commits WHERE url = ?', url].first).not_to be_nil
        check_expected(db['SELECT * FROM commits WHERE url = ?', url].first)
      end
    end

    it 'does not insert the commit if it already exists' do
      get_connection(db_name) do |db|
        save_twice(db) # Attempt to insert again
        result = db['SELECT count(*) as c FROM commits WHERE url = ?', url].first
        expect(result[:c]).to eq(1) # Should only be one entry
      end
    end
  end
end
