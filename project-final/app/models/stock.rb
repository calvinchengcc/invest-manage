class Stock < ActiveRecord::Base
  belongs_to :exchange, primary_key: :code
  has_many :holdings

  validate :listed_on_us_exchange

  before_validation :lookup_exchange_and_name_if_not_given

  def listed_on_us_exchange
    unless Exchange.exists?(code: self.exchange_id)
      errors.add(self.symbol, 'is not listed on a US stock exchange.')
    end
  end

  def lookup_exchange_and_name_if_not_given
    self.exchange_id ||= StockQuote::Stock.quote(self.symbol).stock_exchange
    self.name ||= StockQuote::Stock.quote(self.symbol).name
  end
end
