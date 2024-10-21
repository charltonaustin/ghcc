# frozen_string_literal: true

require 'rspec'
require_relative 'toggle'

RSpec.describe 'toggle' do
  it 'toggle_repo' do
    allow(Repos).to receive(:toggle_to_process)
    toggle_repo('db', 'logger', 'org', 'name')
    expect(Repos).to have_received(:toggle_to_process).with('db', 'logger', 'org', 'name')
  end
end
