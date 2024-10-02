# frozen_string_literal: true

require 'rspec'
require_relative 'list'

def given_repository_returns_mixed_users
  allow(Users::Repository).to receive(:get_users).and_return [
    { user_name: 'username', name: 'name',
      to_process: true }, { user_name: 'username1', name: 'name1', to_process: false }
  ]
end

RSpec.describe 'List' do
  context 'when list_users_from is called' do
    it 'displays all users' do
      allow(Users::Repository).to receive(:get_users).and_return [{ user_name: 'username', name: 'name',
                                                                    to_process: false }]
      expect do
        Users::List.list_users_from(object_double('db').as_null_object, '', false)
      end.to output(/Username: username, name: name, to_process: false/).to_stdout
    end

    it 'displays matched users' do
      allow(Users::Repository).to receive(:get_users).and_return [{ user_name: 'username', name: 'name',
                                                                    to_process: false }]
      expect do
        Users::List.list_users_from(object_double('db').as_null_object, 'name', false)
      end.to output(/Username: username, name: name, to_process: false/).to_stdout
    end

    it 'displays matched users for processable users' do
      given_repository_returns_mixed_users
      expect do
        Users::List.list_users_from(object_double('db').as_null_object, 'name', true)
      end.to output(/Username: username, name: name, to_process: true/).to_stdout
    end
  end
end
