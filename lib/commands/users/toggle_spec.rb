# frozen_string_literal: true

require 'rspec'
require_relative 'toggle'

RSpec.describe 'toggle_user' do
  let(:db) { double('db').as_null_object }
  let(:logger) { double('logger').as_null_object }

  before do
    allow(Users::Repository).to receive(:toggle_by_username)
    allow(Users::Repository).to receive(:toggle_by_name)
  end

  it 'calls toggle_by_username when username given' do
    toggle_user(db, logger, 'username', nil)

    expect(Users::Repository).to have_received(:toggle_by_username).exactly(1).times.with(db, logger, 'username')
  end

  it 'calls toggle_by_username when username and Name given' do
    toggle_user(db, logger, 'username', 'Name')

    expect(Users::Repository).to have_received(:toggle_by_username).exactly(1).times.with(db, logger, 'username')
  end

  it 'calls toggle_by_name when no username given' do
    toggle_user(db, logger, nil, 'Name')

    expect(Users::Repository).to have_received(:toggle_by_name).exactly(1).times.with(db, logger, 'Name')
  end

  it 'does not call toggle_by_name when username given' do
    toggle_user(db, logger, 'username', 'Name')

    expect(Users::Repository).to have_received(:toggle_by_name).exactly(0).times
  end
end
