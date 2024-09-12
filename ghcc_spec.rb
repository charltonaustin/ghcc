# frozen_string_literal: true

require 'rspec'

RSpec.describe 'ghcc' do
  it 'loads' do
    expect(`./ghcc dev -h`).to include('Symlinks')
  end
end
