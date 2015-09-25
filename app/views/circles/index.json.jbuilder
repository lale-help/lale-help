json.center @center

json.circles do
  json.array!(@circles) do |circle|
    json.(circle, :id, :name, :volunteer_count, :open_task_count)
    json.location circle.location
  end
end