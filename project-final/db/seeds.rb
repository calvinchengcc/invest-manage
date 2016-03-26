# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'smarter_csv'

def main
  seed_record('exchanges', Exchange)
  puts 'ADDED STOCK EXCHANGES'

  seed_record('stocks', Stock)
  puts 'ADDED STOCKS'

  seed_record('addresses', Address)
  puts 'ADDED ADDRESSES'

  seed_record('users', User)
  puts 'ADDED USERS'

  seed_record('portfolios', Portfolio)
  puts 'ADDED PORTFOLIOS'

  seed_record('holdings', Holding)
  puts 'ADDED HOLDINGS'
end

def parse_csv_file(filename)
  file = File.join(Dir.pwd, 'db', 'seeds', "#{filename}.csv")
  SmarterCSV.process file
end

def seed_record(filename, record)
  data = parse_csv_file(filename)
  ActiveRecord::Base.transaction do
    data.each { |row| record.create!(row) unless record.exists?(row[:id]) }
  end
end

main
