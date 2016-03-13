class Portfolio < ActiveRecord::Base
  has_many :holdings, dependent: :restrict_with_error
  belongs_to :owner, class_name: 'User'
  belongs_to :manager, class_name: 'User'

  def current_value
    cash + current_value_of_holdings
  end

  def current_value_of_holdings
    symbols = self.holdings.map(&:stock).map(&:symbol)
    return 0 if symbols.empty?
    Array.wrap(StockQuote::Stock.quote(symbols))
        .map(&:last_trade_price_only)
        .zip(self.holdings.map(&:num_shares))
        .map { |a| a[0] * a[1] }.reduce(:+)
  end

  def profit_loss
    current_value - principal
  end

  def annualized_return
    (current_value / principal) ** (1 / years_since(creation_date)) - 1 * 100
  end

  def total_return
    (current_value / principal - 1) * 100
  end

  private

  def years_since(date)
    (Date::today.to_time - date.to_time) / 1.year.seconds
  end
end
