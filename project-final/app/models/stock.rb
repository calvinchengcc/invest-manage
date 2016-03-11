class Stock < ActiveRecord::Base
  belongs_to :exchange
  has_many :holdings

  validate :listed_on_us_exchange

  before_validation :lookup_exchange_and_name_if_not_given

  def listed_on_us_exchange
    unless Exchange.exists?(self.exchange_id)
      errors.add(self.symbol, 'is not listed on a US stock exchange.')
    end
  end

  def lookup_exchange_and_name_if_not_given
    query = StockQuote::Stock.quote(self.symbol)
    self.exchange_id ||= Exchange.find_by!(code: query.stock_exchange).id
    self.name ||= query.name
    puts("#{self.exchange_id} #{self.name}")
  end
end
