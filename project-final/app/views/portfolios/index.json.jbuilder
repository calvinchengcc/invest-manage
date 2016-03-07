json.array!(@portfolios) do |portfolio|
  json.extract! portfolio, :id, :purpose, :creation_date, :principal, :cash, :owner_id, :manager_id
  json.url portfolio_url(portfolio, format: :json)
end
