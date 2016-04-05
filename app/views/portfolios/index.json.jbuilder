json.array!(@portfolios) do |portfolio|
  json.ignore_nil!
  json.(portfolio, *(Portfolio.column_names - @hidden_cols))
  json.url portfolio_url(portfolio, format: :json)
end
