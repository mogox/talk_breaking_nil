params = { id: 1234, lesson_id: 2024 }

def mark_lesson_complete(params)
  user = User.find_by(params[:user_id])
  user&.complete(params[:lesson_id])
end


mark_lesson_complete(params)

# Result: User with ID 1 was marked as complete
(user<id: 1>).complete(lesson_id: 2024)


