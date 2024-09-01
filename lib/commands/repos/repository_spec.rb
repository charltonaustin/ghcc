# frozen_string_literal: true

require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'

def insert_twice(db, repos)
  Reviews.insert(db, repos)
  Reviews.insert(db, repos)
end

def toggle_twice(db)
  Repos.toggle_to_process(db, double('logger').as_null_object, 'test_org', 'test_name')
  Repos.toggle_to_process(db, double('logger').as_null_object, 'test_org', 'test_name')
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

  it 'to add and list' do
    get_connection(db_name) do |db|
      Repos.save(db, 'test_org', 'test_name')
      expect(Repos.get_all(db)).to eq([{ id: 1, name: 'test_name', organization: 'test_org',
                                         to_process: true }])
    end
  end

  it 'to toggles on' do
    get_connection(db_name) do |db|
      Repos.save(db, 'test_org', 'test_name')
      Repos.toggle_to_process(db, double('logger').as_null_object, 'test_org', 'test_name')
      expect(Repos.get_all(db)).to eq([{ id: 1, name: 'test_name', organization: 'test_org', to_process: false }])
    end
  end

  it 'to toggles off' do
    get_connection(db_name) do |db|
      Repos.save(db, 'test_org', 'test_name')
      toggle_twice(db)
      expect(Repos.get_all(db)).to eq([{ id: 1, name: 'test_name', organization: 'test_org', to_process: true }])
    end
  end
end
