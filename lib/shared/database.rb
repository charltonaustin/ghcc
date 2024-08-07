require "sequel"
# noinspection RubyConstantNamingConvention
def get_connection(db_name = "ghcc.db")
  Sequel.connect("sqlite://#{__dir__}/../../data/#{db_name}") do |db|
     yield(db)
  end
end

def delete_database(db_name = "test.db")
  location = "#{__dir__}/../../data/#{db_name}"
  File.delete(location) if File.exist?(location)
end

