json.array!(@working_groups) do |working_group|
  json.extract! working_group, :id
  json.url working_group_url(working_group, format: :json)
end
