# frozen_string_literal: true

require 'rspec'
require_relative 'refresh'
require 'ostruct'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe 'PRS' do
  let(:db) { double('Database') }
  let(:client) { double('Client').as_null_object }
  let(:logger) { double('Logger', debug: nil) }
  let(:repo) { { organization: 'org', name: 'repo' } }
  let(:repos) { [repo] }
  let(:now) { Time.now }
  let(:pull_request) do
    double('pull_request',
           html_url: 'http://example.com', created_at: now, user: double('user', login: 'user'), number: 1)
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

  before do
    allow(client).to receive(:pull_requests).and_return([pull_request])
    allow(PRS).to receive_messages(get_repos_to_process: repos)
    allow(PRS).to receive(:save_pull_request)
    allow(PRS).to receive(:get_latest_pull_requests).and_return({ number: 0 })
  end

  it 'refresh_pull_requests without saved prs' do
    allow(PRS).to receive(:saved_pull_request?).and_return(false)
    PRS.refresh_pull_requests(db, client, logger)
    expect(PRS).to have_received(:save_pull_request).with(db, pull_request, 'org/repo', 1)
  end

  it 'refresh_pull_requests with saved prs' do
    allow(PRS).to receive(:saved_pull_request?).and_return(true)
    PRS.refresh_pull_requests(db, client, logger)
    expect(PRS)
      .to have_received(:save_pull_request)
      .with(db, { created_at: now, url: 'http://example.com', user_name: 'user' }, 'org/repo', 1)
  end
end
