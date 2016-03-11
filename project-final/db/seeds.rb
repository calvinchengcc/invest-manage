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

  put_user_data('users')
  puts 'ADDED USERS'

  put_csv_data_in_record('portfolios', Portfolio)
  puts 'ADDED PORTFOLIOS'

  put_csv_data_in_record('holdings', Holding)
  puts 'ADDED HOLDINGS'
end

def parse_csv_file(filename)
  file = File.join(Dir.pwd, 'db', 'seeds', "#{filename}.csv")
  SmarterCSV.process file
end

def put_csv_data_in_record(filename, record)
  data = parse_csv_file(filename)
  ActiveRecord::Base.transaction do
    data.each do |row|
      record.find_or_create_by! row
    end
  end
end

def put_user_data(filename)
  data = parse_csv_file filename
  ActiveRecord::Base.transaction do
    data.each do |row|
      User.create(row) if User.find_by(email: row[:email]).nil?
    end
  end
end

main
