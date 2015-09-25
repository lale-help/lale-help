json.center @center

json.circles do
  json.array!(@circles) do |circle|
    json.(circle, :id, :name)
    json.location circle.location
  end
end