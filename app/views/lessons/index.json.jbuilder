json.array!(@lessons) do |lesson|
  json.extract! lesson, :id, :student_id, :teacher_id, :starting_time
  json.url lesson_url(lesson, format: :json)
end
