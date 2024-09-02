# frozen_string_literal: true

require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'

def insert_twice(db, repos)
  Reviews.insert(db, repos)
  Reviews.insert(db, repos)
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

  it 'saves a review in an idempotent way' do
    get_connection(db_name) do |db|
      repos = { submitted_at: Date.today.to_s, user: 'user', repository: 'repository', html_url: 'test_url' }
      insert_twice(db, repos)

      expect(db['SELECT * FROM reviews'].all.size).to eq(1)
    end
  end

  it 'saves and retrieve' do
    get_connection(db_name) do |db|
      repos = { submitted_at: Date.today.to_s, user: 'user', repository: 'repository', html_url: 'test_url' }
      Reviews.insert(db, repos)

      expect(Reviews.check_for(db, 'test_url')).to be_truthy
    end
  end
end
