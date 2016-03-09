# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'smarter_csv'

user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

exchange_data_file = File.join(Dir.pwd, 'db', 'seeds', 'stock_exchange_codes.csv')
exchange_data = SmarterCSV.process exchange_data_file
ActiveRecord::Base.transaction do
  exchange_data.each do |row|
    Exchange.find_or_create_by!(code: row[:code]) do |exchange|
      exchange.name = row[:name]
    end
  end
end
puts 'ADDED STOCK EXCHANGE CODES'

