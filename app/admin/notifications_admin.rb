Trestle.resource(:notifications) do
  menu do
    item :notifications, icon: "fa fa-bell"
  end
  scopes do
    scope :all, -> { Notification.all }, default: true
  end
  table do
    column :id
    column :from_user, ->(notification) { "#{notification.user.try(:full_name)} <#{notification.user.try(:email)}>" }
    column :to_user, ->(notification) { "#{notification.to_user.try(:full_name)} <#{notification.to_user.try(:email)}>" }
    column :notification_type
    column :notification_text, ->(notification) { format(notification.notification_text, trainer_name: notification.user.try(:full_name), client_name: '', task_name: notification.meal_id.present? ? notification.try(:meal).try(:title) : (notification.workout_id.present? ? notification.try(:workout).try(:title) : ''), option: notification.user.try(:objective), new_weight: notification.user.try(:weight), n: notification.to_user && notification.to_user.clients.present? ? notification.to_user.clients.where(created_at: Date.today).count : '', day: notification.meal_id.present? && notification.meal.present? ? notification.meal.meal_time.strftime('%m/%d/%Y') : (notification.workout_id.present? && notification.workout.present? ? notification.workout.date.strftime('%m/%d/%Y') : '')) }
    column :meal_id
    column :workout_id
    column :created_at, ->(notification) { notification.created_at + Time.zone_offset('EST') } 
  end


  controller do
    def index
      @dont_display_new_link = true
      @notifications =  Notification.all
      @count = @notifications.size
    end
  end

  routes do

  end

end
    