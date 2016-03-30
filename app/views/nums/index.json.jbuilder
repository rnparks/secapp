json.array!(@nums) do |num|
  json.extract! num, :id
  json.url num_url(num, format: :json)
end
