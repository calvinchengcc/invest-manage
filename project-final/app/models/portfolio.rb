class Portfolio < ActiveRecord::Base
  has_many :holdings, inverse_of: :portfolio
  belongs_to :owner, class_name: 'User'
  belongs_to :manager, class_name: 'User'

  def current_value
    cash + current_value_of_holdings
  end

  def current_value_of_holdings
    symbols = holdings.map(&:stock).map(&:symbol)
    return 0 if symbols.empty?
    Array.wrap(StockQuote::Stock.quote(symbols))
        .map(&:last_trade_price_only)
        .zip(self.holdings.map(&:num_shares))
        .map { |a| a[0] * a[1] }
        .reduce(:+)
        .round(2)
  end

  def profit_loss
    (current_value - principal).round(2)
  end

  def annualized_return
    age = [years_since(creation_date), 1.0 / (365 * 24 * 24)].max
    ((((current_value / principal) ** (1 / age)) - 1) * 100).round(2)
  end

  def total_return
    ((current_value / principal - 1) * 100).round(2)
  end

  def companies_represented
    holdings.map(&:stock).uniq
  end

  def to_s
    "#{owner.name}'s #{purpose} portfolio (created on #{creation_date.to_formatted_s(:long)})"
  end

  private

  def years_since(date)
    (Date::today.to_time - date.to_time) / 1.year.seconds
  end
end
