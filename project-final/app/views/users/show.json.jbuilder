json.extract! @user, :id, :name, :email, :role, :phone, :address_id
json.owned_portfolios do
	json.array! @user.owned_portfolios, :id, :purpose, :principal, :cash, :owner, :manager
end
json.managed_portfolios do
	json.array! @user.managed_portfolios, :id, :purpose, :principal, :cash, :owner, :manager
end
