json.array!(@stocks) do |stock|
  json.extract! stock, :id, :symbol, :exchange, :name
  json.url stock_url(stock, format: :json)
end
