class NotificationSerializer
  include FastJsonapi::ObjectSerializer
  attribute :notification_type, :status

  attribute :notification_text do |object|
    format(object.notification_text, trainer_name: object.user.full_name, client_name: '', task_name: object.meal_id.present? ? object.try(:meal).try(:title) : (object.workout_id.present? ? object.try(:workout).try(:title) : ''), option: object.user.objective, new_weight: object.user.weight, n: object.to_user.clients.where(created_at: Date.today).count, day: object.meal_id.present? && object.meal.present? ? object.meal.meal_time.strftime('%m/%d/%Y') : (object.workout_id.present? && object.workout.present? ? object.workout.date.strftime('%m/%d/%Y') : ''))
  end

  attribute :created_at do |object|
    object.created_at.utc
  end

  attribute :from_user do |object|
    AMS::UserSerializer.new(object.user)
  end

  attribute :to_user do |object|
    AMS::UserSerializer.new(object.to_user)
  end
  
  attribute :client_id do |object|
    !object.to_user.trainer? ? object.to_user_id : object.user_id
  end

  attribute :meal_id do |object|
    object.meal_id.present? ? object.meal_id : 0
  end

  attribute :workout_id do |object|
    object.workout_id.present? ? object.workout_id : 0
  end
end
