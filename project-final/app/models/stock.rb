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

  def update_quote
    @quote ||= StockQuote::Stock.quote(symbol)
  end

  def current_price
    update_quote
	@quote.last_trade_price_only
  end

  def last_trade_date_time
    update_quote
    { date: @quote.last_trade_date, time: @quote.last_trade_time }
  end

  def current_change
    update_quote
    @quote.change
  end

  def current_change_percent
    update_quote
    @quote.changein_percent
  end

  def historical_price_10d
    StockQuote::Stock.history(symbol, Date.today - 10, Date.today).map{|x| { price: x.close.round(2), date: x.date } }
  end

  def historical_price_365d
    StockQuote::Stock.history(symbol, Date.today - 365, Date.today).map{|x| { price: x.close.round(2), date: x.date } }
  end

end
