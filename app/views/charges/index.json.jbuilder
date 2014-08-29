json.array!(@charges) do |charge|
  json.extract! charge, :id, :user_id, :sale_id, :plan_id
  json.url charge_url(charge, format: :json)
end
