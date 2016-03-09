class Stock < ActiveRecord::Base
  belongs_to :stock_exchange, primary_key: :exchange_code
  has_many :holdings
end
