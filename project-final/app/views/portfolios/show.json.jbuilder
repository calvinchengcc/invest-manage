json.extract! @portfolio, :id, :purpose, :creation_date, :principal, :owner_id, :manager_id, :creation_date
json.cash '%.2f' % @portfolio.cash
json.principal '%.2f' % @portfolio.principal
json.holdings do
	json.array! @portfolio.holdings do |holding|
		json.extract! holding, :id, :num_shares, :price
		json.stock do
			json.extract! holding.stock, :id, :name, :symbol, :exchange, :current_price, :current_change_percent
			json.stats do
				json.extract! holding.stock.quote, :days_range, :year_range, :open, :volume, :average_daily_volume, :market_capitalization, :dividend_share, :dividend_yield, :earnings_share, :ask, :bid
			end
		end
	end
end
