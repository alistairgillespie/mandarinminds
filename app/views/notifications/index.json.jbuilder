json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :image, :content, :dismissed, :link
  json.url notification_url(notification, format: :json)
end
