# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'smarter_csv'

def main
  Holding.delete_all
  Portfolio.delete_all
  User.delete_all
  Address.delete_all
  Stock.delete_all
  Exchange.delete_all
  puts 'All TABLES DELETED'

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

  reset_db_sequence
end

def parse_csv_file(filename)
  file = File.join(Dir.pwd, 'db', 'seeds', "#{filename}.csv")
  SmarterCSV.process file
end

def seed_record(filename, record, validate = false)
  data = parse_csv_file(filename).map { |row| record.new(row) }
  record.import data, validate: validate
end

def reset_db_sequence
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
end

main
