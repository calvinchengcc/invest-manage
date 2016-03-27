json.ignore_nil!
json.(@user, :id, :name, :email, :role, :phone, :address_id)
json.owned_portfolios do
	json.array! @user.owned_portfolios do |portfolio|
		json.extract! portfolio, :id, :purpose, :owner, :manager
		json.cash '%.2f' % portfolio.cash
		json.principal '%.2f' % portfolio.principal
	end
end
json.managed_portfolios do
	json.array! @user.owned_portfolios do |portfolio|
		json.extract! portfolio, :id, :purpose, :owner, :manager
		json.cash '%.2f' % portfolio.cash
		json.principal '%.2f' % portfolio.principal
  end
end
json.companies @companies
