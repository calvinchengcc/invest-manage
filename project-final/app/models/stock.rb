class Stock < ActiveRecord::Base
  belongs_to :exchange
  has_many :holdings

  before_validation :lookup_name_and_exchange_if_needed
  validate :listed_on_us_exchange
  validates :symbol, :exchange_id, :name, presence: true

  def lookup_name_and_exchange_if_needed
    if name.nil? || exchange.nil?
      query = StockQuote::Stock.quote(self.symbol)
      self.exchange ||= Exchange.find_by(code: query.stock_exchange)
      self.name ||= query.name
    end
  end

  def listed_on_us_exchange
    unless Exchange.exists?(exchange_id)
      errors.add(symbol, 'is not listed on a US stock exchange.')
    end
  end

  def current_price
    StockQuote::Stock.quote(symbol).last_trade_price_only
  end

  def current_change
    StockQuote::Stock.quote(symbol).change
  end

  def current_change_percent
    StockQuote::Stock.quote(symbol).changein_percent
  end

  def historical_price
    StockQuote::Stock.history(symbol, Date.today - 10, Date.today).map{|x| { price: x.close.round(2), date: x.date } }
  end

end
