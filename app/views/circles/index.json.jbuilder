json.array!(@circles) do |circle|
  json.extract! circle, :id
  json.url circle_url(circle, format: :json)
end
