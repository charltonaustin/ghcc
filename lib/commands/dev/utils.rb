# frozen_string_literal: true

module Dev
  def self.create_db_file
    db_path = File.expand_path("#{__FILE__}/../../../../data")
    FileUtils.mkdir_p(db_path)
    db_file = File.join(db_path, 'ghcc.db')
    FileUtils.touch(db_file) unless File.exist?(db_file)
  end
end
