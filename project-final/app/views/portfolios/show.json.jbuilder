json.extract! @portfolio, :id, :purpose, :creation_date, :principal, :cash, :owner_id, :manager_id, :creation_date
json.holdings do
	json.array! @portfolio.holdings do |holding|
		json.extract! holding, :id, :num_shares, :price
		json.stock do
			json.extract! holding.stock, :id, :name, :symbol, :exchange, :current_price, :current_change_percent
		end
	end
end
