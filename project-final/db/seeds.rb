# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'smarter_csv'

def main
  user = CreateAdminService.new.call
  puts 'CREATED ADMIN USER: ' << user.email

  put_csv_data_in_record('exchanges', Exchange)
  puts 'ADDED STOCK EXCHANGES'

  put_csv_data_in_record('stocks', Stock)
  puts 'ADDED STOCKS'

  put_csv_data_in_record('addresses', Address)
  puts 'ADDED ADDRESSES'

  # TODO
  puts 'ADDED USERS'
end

def put_csv_data_in_record(filename, record)
  file = File.join(Dir.pwd, 'db', 'seeds', "#{filename}.csv")
  data = SmarterCSV.process file
  ActiveRecord::Base.transaction do
    data.each do |row|
      record.find_or_create_by! row
    end
  end
end

main
