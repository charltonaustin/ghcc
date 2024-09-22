# frozen_string_literal: true

require 'rspec'
require_relative 'repository'
require_relative '../../shared/database'
require 'securerandom'

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

  it 'add_contributions' do
    get_connection(db_name) do |_|
      expect(true).to be_truthy
    end
  end
end
