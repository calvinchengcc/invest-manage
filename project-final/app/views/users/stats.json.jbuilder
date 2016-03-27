json.ignore_nil!
json.(@stats, *@stats.keys)
json.principal_by_country do
  json.(@principal_by_country, *@principal_by_country.keys)
end
