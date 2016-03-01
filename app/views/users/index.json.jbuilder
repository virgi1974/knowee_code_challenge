json.array!(@users) do |user|
  json.extract! user, :id, :nombre
  json.url user_url(user, format: :json)
end
