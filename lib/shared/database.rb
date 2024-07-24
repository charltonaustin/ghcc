require "sequel"
# noinspection RubyConstantNamingConvention
def get_connection
  Sequel.connect("sqlite://#{__dir__}/../../data/ghcc.db") do |db|
     yield(db)
  end
end