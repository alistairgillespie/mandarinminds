json.array!(@lessons) do |lesson|
  json.extract! lesson, :id, :student_id, :teacher_id, :starts_at
  json.url lesson_url(lesson, format: :json)
end
