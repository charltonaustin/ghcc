# frozen_string_literal: true

require 'rspec'
require_relative 'refresh'

RSpec.describe 'refresh' do
  describe '#log_commits' do
    let(:commit) do
      author_double = double('author', date: '2024-09-12')
      commit_double = double('commit', author: author_double, committer: double('committer', name: 'John Doe'))
      double('commit', commit: commit_double, html_url: 'http://example.com/commit')
    end
    let(:display_name) { 'John Doe' }
    let(:logger) { double('logger').as_null_object }
    let(:repo) { 'example_repo' }

    it 'logs the date' do
      log_commits(commit, display_name, logger, repo)
      expect(logger).to have_received(:debug).with('date: 2024-09-12')
    end

    it 'logs the username' do
      log_commits(commit, display_name, logger, repo)
      expect(logger).to have_received(:debug).with("username: #{display_name}")
    end

    it 'logs the repo' do
      log_commits(commit, display_name, logger, repo)
      expect(logger).to have_received(:debug).with("repo: #{repo}")
    end

    it 'logs the commit URL' do
      log_commits(commit, display_name, logger, repo)
      expect(logger).to have_received(:debug).with('commit.html_url: http://example.com/commit')
    end
  end

  describe '#get_name' do
    let(:db) { double('db') }
    let(:commit) do
      committer_double = double('committer', name: 'John Doe')
      commit_double = double('commit', author: double('author', date: '2024-09-12'), committer: committer_double)
      double('commit', commit: commit_double, html_url: 'http://example.com/commit')
    end

    it 'returns the username from the database if available' do
      allow(self).to receive(:get_user_name).with(db, 'John Doe').and_return('johndoe123')
      result = get_name(commit, db)
      expect(result).to eq('johndoe123')
    end

    it 'returns the committer name if username is not available in the database' do
      allow(self).to receive(:get_user_name).with(db, 'John Doe').and_return(nil)
      result = get_name(commit, db)
      expect(result).to eq('John Doe')
    end
  end

  describe '#refresh_commits' do
    let(:db) { double('db') }
    let(:logger) { double('logger').as_null_object }
    let(:repo) { 'example_repo' }
    let(:client) { double('git_client') }
    let(:commit) do
      double('commit',
             commit: double('commit', author: double('author', date: '2024-09-12'),
                                      committer: double('committer', name: 'John Doe')),
             html_url: 'http://example.com/commit')
    end

    before do
      allow(client).to receive(:list_commits).with(repo.to_s).and_return([commit])
      allow(self).to receive(:log_commits)
      allow(self).to receive(:save_commit)
      allow(self).to receive(:get_name).and_return('John Doe')
    end

    it 'calls log_commits for each commit' do
      refresh_commits(db, client, repo, logger)
      expect(self).to have_received(:log_commits).with(commit, 'John Doe', logger, repo)
    end

    it 'calls save_commit for each commit' do
      refresh_commits(db, client, repo, logger)
      expect(self).to have_received(:save_commit).with(db, '2024-09-12', 'John Doe', repo, 'http://example.com/commit')
    end
  end
end
