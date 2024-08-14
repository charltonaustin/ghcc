# frozen_string_literal: true

require 'rspec'
require_relative 'list'

RSpec.describe 'List' do
  context 'when list_users_from is called' do
    it 'displays all users' do
      allow(Users::Repository).to receive(:get_users).and_return [{ user_name: 'username', name: 'name',
                                                                    to_process: false }]
      expect do
        Users::List.list_users_from(object_double('db').as_null_object, '', false)
      end.to output(/Username: username, name: name, to_process: false/).to_stdout
    end
  end
end
