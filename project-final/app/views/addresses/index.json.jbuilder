json.array!(@addresses) do |address|
  json.extract! address, :id, :number, :street, :city, :country, :postal_code
  json.url address_url(address, format: :json)
end
