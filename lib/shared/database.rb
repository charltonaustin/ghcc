# frozen_string_literal: true

require 'sequel'
require 'fileutils'
# noinspection RubyConstantNamingConvention
def get_connection(db_name = 'ghcc.db', &)
  Sequel.connect("sqlite://#{__dir__}/../../data/#{db_name}", &)
end

def delete_database(db_name = 'test.db')
  location = "#{__dir__}/../../data/#{db_name}"
  FileUtils.rm_f(location)
end
