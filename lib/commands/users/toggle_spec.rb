require 'rspec'
require_relative 'toggle'

RSpec.describe 'toggle_user' do
  it 'should call toggle_by_username when username given' do
    allow(self).to receive(:toggle_by_username)
    db = double("db").as_null_object
    logger = double("logger").as_null_object
    
    toggle_user(db, logger, "username", nil)

    expect(self).to have_received(:toggle_by_username).exactly(1).times.with(db,logger, "username")
  end

  it 'should call toggle_by_username when username and Name given' do
    allow(self).to receive(:toggle_by_username)
    db = double("db").as_null_object
    logger = double("logger").as_null_object

    toggle_user(db, logger, "username", "Name")

    expect(self).to have_received(:toggle_by_username).exactly(1).times.with(db,logger, "username")
  end

  it 'should call toggle_by_name when no username given' do
    allow(self).to receive(:toggle_by_name)
    db = double("db").as_null_object
    logger = double("logger").as_null_object

    toggle_user(db, logger, nil, "Name")

    expect(self).to have_received(:toggle_by_name).exactly(1).times.with(db,logger, "Name")
  end

  it 'should call toggle_by_name when no username given' do
    allow(self).to receive(:toggle_by_username)
    allow(self).to receive(:toggle_by_name)
    db = double("db").as_null_object
    logger = double("logger").as_null_object

    toggle_user(db, logger, "username", "Name")

    expect(self).to have_received(:toggle_by_name).exactly(0).times
  end
end