# frozen_string_literal: true

require 'rspec'
require_relative 'user_details'

def given
  allow(self).to receive('puts')
  allow(self).to receive('log_details')
  allow(self).to receive('calculate').and_return([[], 'name', [], [], 'review string'])
  logger = double('logger')
  date_range = double('date_range')
  user_contributions = double('user_contributions')
  [date_range, logger, user_contributions]
end

RSpec.describe 'user_details' do
  describe '#format_commits' do
    let :user_details do
      { commits: [
        { url: 'http://example.com/commit1', creation: Time.new(2024, 9, 15) },
        { url: 'http://example.com/commit2', creation: Time.new(2024, 9, 16) }
      ] }
    end

    it 'formats commit data correctly' do
      expected_output = ['http://example.com/commit1, 2024-09-15', 'http://example.com/commit2, 2024-09-16']
      expect(format_commits(user_details)).to eq(expected_output)
    end
  end

  describe '#user_details' do
    let(:app_context) { { db: double('DB'), logger: double('Logger', debug: nil) } }
    let(:date_range) { { start_date: '2024-09-01', end_date: '2024-09-15' } }
    let(:uname) { 'johndoe' }
    let(:name) { 'John Doe' }
    let(:user_contributions) { { commits: [], pull_requests: [], reviews: [], user_name: uname, name: } }

    before do
      allow(self).to receive(:get_contributions_uname).with(app_context[:db], app_context[:logger], date_range,
                                                            uname).and_return(user_contributions)
      allow(self).to receive(:get_contributions_name).with(app_context[:db], app_context[:logger], date_range,
                                                           name).and_return(user_contributions)
      allow(self).to receive(:print_details)
    end

    it 'fetches contributions by username when uname is provided' do
      user_details(app_context, date_range, uname, nil, false)
      expect(self).to have_received(:get_contributions_uname).with(app_context[:db], app_context[:logger], date_range,
                                                                   uname)
    end

    it 'fetches contributions by name when name is provided' do
      user_details(app_context, date_range, nil, name, false)
      expect(self).to have_received(:get_contributions_name).with(app_context[:db], app_context[:logger], date_range,
                                                                  name)
    end

    it 'prints details of user contributions' do
      user_details(app_context, date_range, uname, nil, false)
      expect(self).to have_received(:print_details).with(app_context[:logger], date_range, user_contributions,
                                                         false)
    end
  end

  describe '#format_prs' do
    let(:user_contributions) do
      { pull_requests: [
        { url: 'http://example.com/pr1', pr_creation: Time.new(2024, 9, 15) },
        { url: 'http://example.com/pr2', pr_creation: Time.new(2024, 9, 16) }
      ] }
    end

    it 'formats pull request data correctly' do
      expected_output = ['http://example.com/pr1, 2024-09-15', 'http://example.com/pr2, 2024-09-16']
      expect(format_prs(user_contributions)).to eq(expected_output)
    end
  end

  describe '#format_reviews' do
    let(:user_contributions) do
      { reviews: [
        { url: 'http://example.com/review1', creation: Time.new(2024, 9, 15) },
        { url: 'http://example.com/review2', creation: Time.new(2024, 9, 16) }
      ] }
    end

    it 'formats review data correctly' do
      expected_output = ['http://example.com/review1, 2024-09-15', 'http://example.com/review2, 2024-09-16']
      expect(format_reviews(user_contributions)).to eq(expected_output)
    end
  end

  describe '#name' do
    let(:user_contributions_with_name) { { name: 'John Doe', user_name: 'johndoe' } }
    let(:user_contributions_without_name) { { user_name: 'janedoe' } }

    it 'returns the name if present' do
      expect(name(user_contributions_with_name)).to eq('John Doe')
    end

    it 'returns the user_name if name is nil' do
      expect(name(user_contributions_without_name)).to eq('janedoe')
    end
  end

  describe '#print_string_for' do
    it 'formats the string correctly for given name and contributions' do
      name = 'commits'
      contributions = ['http://example.com/commit1, 2024-09-15', 'http://example.com/commit2, 2024-09-16']
      expected_output = "\ncommits: 2\nhttp://example.com/commit1, 2024-09-15\nhttp://example.com/commit2, 2024-09-16"
      expect(print_string_for(name, contributions)).to eq(expected_output)
    end
  end

  describe '#calculate_review_string' do
    let(:reviews_urls) { ['http://example.com/review1, 2024-09-15', 'http://example.com/review2, 2024-09-16'] }

    let(:user_contributions) do
      {
        commits: [
          { url: 'http://example.com/commit1', creation: Time.new(2024, 9, 15) },
          { url: 'http://example.com/commit2', creation: Time.new(2024, 9, 16) }
        ],
        pull_requests: [
          { url: 'http://example.com/pr1', pr_creation: Time.new(2024, 9, 15) },
          { url: 'http://example.com/pr2', pr_creation: Time.new(2024, 9, 16) }
        ],
        reviews: [
          { url: 'http://example.com/review1', creation: Time.new(2024, 9, 15) },
          { url: 'http://example.com/review2', creation: Time.new(2024, 9, 16) }
        ]
      }
    end
    let(:date_range) { { start_date: '2024-09-01', end_date: '2024-09-15' } }
    let(:logger) { double('Logger', debug: nil) }

    it 'returns an empty string when ignore_reviews is true' do
      expect(calculate_review_string(true, reviews_urls)).to eq('')
    end

    it 'returns formatted review string when ignore_reviews is false' do
      expected_output = "\nreviews: 2\nhttp://example.com/review1, 2024-09-15\nhttp://example.com/review2, 2024-09-16"
      expect(calculate_review_string(false, reviews_urls)).to eq(expected_output)
    end

    it 'logs user contributions' do
      log_details(logger, date_range, user_contributions)
      expect(logger).to have_received(:debug).with("user_contributions: #{user_contributions}")
    end

    it 'logs date range' do
      log_details(logger, date_range, user_contributions)
      expect(logger).to have_received(:debug).with(
        "start_date: #{date_range[:start_date]}, end_date: #{date_range[:end_date]}"
      )
    end

    it 'maps commit URLs correctly' do
      expected_commits = ['http://example.com/commit1, 2024-09-15', 'http://example.com/commit2, 2024-09-16']
      commit_urls, = map_contributions(user_contributions)
      expect(commit_urls).to eq(expected_commits)
    end

    it 'maps pull request URLs correctly' do
      expected_prs = ['http://example.com/pr1, 2024-09-15', 'http://example.com/pr2, 2024-09-16']
      _, prs_urls, = map_contributions(user_contributions)
      expect(prs_urls).to eq(expected_prs)
    end

    it 'maps review URLs correctly' do
      expected_reviews = ['http://example.com/review1, 2024-09-15', 'http://example.com/review2, 2024-09-16']
      _, _, reviews_urls = map_contributions(user_contributions)
      expect(reviews_urls).to eq(expected_reviews)
    end
  end

  describe '#calculate' do
    let(:user_contributions) do
      {
        commits: [
          { url: 'http://example.com/commit1', creation: Time.new(2024, 9, 15) },
          { url: 'http://example.com/commit2', creation: Time.new(2024, 9, 16) }
        ],
        pull_requests: [
          { url: 'http://example.com/pr1', pr_creation: Time.new(2024, 9, 15) },
          { url: 'http://example.com/pr2', pr_creation: Time.new(2024, 9, 16) }
        ],
        reviews: [
          { url: 'http://example.com/review1', creation: Time.new(2024, 9, 15) },
          { url: 'http://example.com/review2', creation: Time.new(2024, 9, 16) }
        ]
      }
    end

    it 'calculates with ignore reviews false' do
      expect(calculate(true, user_contributions)).to contain_exactly(
        ['http://example.com/commit1, 2024-09-15', 'http://example.com/commit2, 2024-09-16'], nil,
        ['http://example.com/pr1, 2024-09-15', 'http://example.com/pr2, 2024-09-16'],
        ['http://example.com/review1, 2024-09-15', 'http://example.com/review2, 2024-09-16'], ''
      )
    end
  end

  describe '#print_details' do
    it 'calls log_details' do
      date_range, logger, user_contributions = given
      print_details(logger, date_range, user_contributions, false)
      expect(self).to have_received(:log_details).with(logger, date_range, user_contributions)
    end

    it 'calls puts' do
      date_range, logger, user_contributions = given
      print_details(logger, date_range, user_contributions, false)
      expect(self).to have_received(:puts).with("name\ntotal: 0review string\ncommits: 0\n\nprs: 0\n")
    end
  end

  describe '#get_contributions_name' do
    let(:db) { double('DB') }
    let(:logger) { double('Logger', debug: nil) }
    let(:name) { 'John Doe' }
    let(:user_name) { 'johndoe' }
    let(:contributions) { { commits: [], pull_requests: [], reviews: [], name:, user_name: } }

    before do
      allow(db).to receive(:[]).with('SELECT user_name FROM users WHERE name = ?',
                                     name).and_return([{ user_name: }])
      allow(self).to receive(:get_contributions_uname).with(db, logger,
                                                            { start_date: '2024-09-01', end_date: '2024-09-15' },
                                                            user_name).and_return(contributions)
    end

    it 'fetches contributions by name' do
      result = get_contributions_name(db, logger, { start_date: '2024-09-01', end_date: '2024-09-15' }, name)
      expect(result).to eq(contributions)
    end

    it 'logs the query' do
      get_contributions_name(db, logger, { start_date: '2024-09-01', end_date: '2024-09-15' }, name)
      expect(logger).to have_received(:debug).with("QUERY IS: SELECT user_name FROM users WHERE name = '#{name}'")
    end

    it 'logs if empty' do
      get_contributions_name(db, logger, { start_date: '2024-09-01', end_date: '2024-09-15' }, name)
      expect(logger).to have_received(:debug).with('ds.empty?: false')
    end
  end

  describe '#get_contributions_uname' do
    let(:db) { double('DB') }
    let(:logger) { double('Logger', debug: nil) }
    let(:uname) { 'johndoe' }
    let(:date_range) { { start_date: '2024-09-01', end_date: '2024-09-15' } }
    let(:contributions) { { commits: [], pull_requests: [], reviews: [], user_name: uname } }

    before do
      allow(self).to receive(:add_contributions).with(db, date_range, uname).and_return(contributions)
    end

    it 'fetches contributions by username' do
      expect(get_contributions_uname(db, logger, date_range, uname)).to eq(contributions)
    end

    it 'includes the username in the contributions' do
      expect(get_contributions_uname(db, logger, date_range, uname)[:user_name]).to eq(uname)
    end
  end
end
