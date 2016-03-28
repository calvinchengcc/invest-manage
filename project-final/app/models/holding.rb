class Holding < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :stock

  def to_s
    "#{num_shares} #{'share'.pluralize(num_shares)} of #{stock.symbol} bought at $#{price}"
  end
end
