json.array!(@filers) do |filer|
  json.extract! filer, :id
  json.url filer_url(filer, format: :json)
end
