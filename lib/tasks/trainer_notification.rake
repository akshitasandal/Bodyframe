desc "Notify trianer daily for client invitations"
task :push_notifications => :environment do
  User.where(trainer_id: nil).each do |user|
    user.trainer_meals.where(done: false).each do |meal|
      current_time = DateTime.current
      before_10_min = (DateTime.current.to_time - 10.minutes).to_datetime
      if (before_10_min..current_time).cover? meal.meal_time
        not_completed_meal = meal.client.notifications.build(notification_type: 6, notification_text: 6, to_user_id: user.id, meal_id: meal.id)
        notification_params = { client_name: meal.client.full_name, task_name: meal.title }
        meal.client.send_notifications(not_completed_meal, notification_params) if not_completed_meal.save
      end
    end
  end

  User.where.not(trainer_id: nil).each do |user|
    user.client_meals.where(done: false).each do |meal|
      current_time = DateTime.current
      before_10_min = (DateTime.current.to_time - 10.minutes).to_datetime
      if (before_10_min..current_time).cover? meal.meal_time
        client_not_completed_meal = user.notifications.build(notification_type: 11, notification_text: 11, to_user_id: user.id, meal_id: meal.id)
        notification_params = { client_name: user.full_name, task_name: meal.title }
        user.send_notifications(client_not_completed_meal, notification_params) if client_not_completed_meal.save
      end
    end
  end
end

task :push_notifications_evening => :environment do
  User.where(trainer_id: nil).each do |user|
    invited_client_today = user.notifications.build(notification_type: 0, notification_text: 0, to_user_id: user.id)
    notification_params = { n: user.clients.where(created_at: Date.today).count }
    user.send_notifications(invited_client_today, notification_params) if invited_client_today.save
    user.trainer_workouts.where(done: false).each do |workout|
      if workout.date == Date.today
        not_completed_workout = workout.client.notifications.build(notification_type: 7, notification_text: 7, to_user_id: user.id, workout_id: workout.id)
        notification_params = { client_name: workout.client.full_name, task_name: workout.title }
        workout.client.send_notifications(not_completed_workout, notification_params) if not_completed_workout.save
      end
    end
  end
  User.where.not(trainer_id: nil).each do |user|
    user.client_workouts.where(done: false).each do |workout|
      if workout.date == Date.today
        client_not_completed_meal = user.notifications.build(notification_type: 11, notification_text: 11, to_user_id: user.id, workout_id: workout.id)
        notification_params = { client_name: user.name, task_name: workout.title }
        user.send_notifications(client_not_completed_meal, notification_params) if client_not_completed_meal.save 
      end
    end
  end
end