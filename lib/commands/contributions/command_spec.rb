# frozen_string_literal: true

require 'rspec'
require 'thor'
require_relative 'command'
require_relative 'process_contributions'

def mock_behavior(command)
  allow(command).to receive(:get_connection).and_yield(double('db').as_null_object)
  allow(command).to receive(:get_logger).and_return(double('logger', debug: nil))
  allow(command).to receive(:display_contributions)
end

def given_for_all
  command = Contributions::Command.new
  command.options = { start_date: '2020-01-01', end_date: '2020-12-31' }
  command.parent_options = {}
  mock_behavior(command)
  command
end

def given_details
  command = Contributions::Command.new
  command.options = { start_date: '2020-01-01', end_date: '2020-12-31' }
  command.parent_options = {}
  mock_behavior(command)
  command
end

RSpec.describe 'command' do
  describe '#details' do
    it 'executes the details command' do
      command = given_details
      command.details
      expect(command).to have_received(:get_connection)
    end
  end

  describe '#all' do
    it 'executes the all command' do
      command = given_for_all
      command.all
      expect(command).to have_received(:display_contributions)
    end
  end
end
