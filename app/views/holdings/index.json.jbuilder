json.array!(@holdings) do |holding|
  json.extract! holding, :id, :holding_id, :portfolio_id, :symbol, :exchange, :num_shares, :datetime, :price
  json.url holding_url(holding, format: :json)
end
