# frozen_string_literal: true

require 'securerandom'
require 'rspec'
require_relative '../shared/database'
require_relative 'read_repository'

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
end
