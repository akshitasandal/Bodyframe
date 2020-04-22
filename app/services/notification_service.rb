require 'hmac-sha1'
class NotificationService
  class << self
    def notifications(device_ids, notification, notification_params)
      fcm = FCM.new( ENV["FCM_SERVER_KEY"])
      android_registration_ids = DeviceToken.where(user_id: notification.to_user_id, device_type: "android").pluck(:device_token)
      ios_registration_ids = DeviceToken.where(user_id: notification.to_user_id, device_type: "ios").pluck(:device_token)
      if android_registration_ids.count > 0
        android_options = {
          "data": {
            "notification_id": notification.id,
            "meal_id": notification.try(:meal_id),
            "workout_id": notification.try(:workout_id),
            "from_user": notification.try(:user).try(:full_name),
            "to_user": notification.try(:to_user).try(:full_name),
            "notification_type": notification.notification_type,
            "notification_text": format(notification.notification_text, trainer_name: notification_params[:trainer_name], client_name: notification_params[:client_name], task_name: notification_params[:task_name], n: notification_params[:n], day: notification_params[:day], option: notification_params[:option], new_weight: notification_params[:new_weight]),
            "client_id": !notification.to_user.trainer? ? notification.to_user_id : notification.user_id,
            "title": "#{notification.user.full_name.capitalize()}",
            "body": "#{format(notification.notification_text, client_name: notification_params[:client_name], task_name: notification_params[:task_name], n: notification_params[:n], trainer_name: notification_params[:trainer_name], day: notification_params[:day], option: notification_params[:option], new_weight: notification_params[:new_weight])}",
            "sound": "default",
            "badge": Notification.where(to_user_id: notification.to_user_id, status: 'unread').count
          },
          "android":{
            "priority": "high"
          },
          "priority": 10,
          "apns":{
            "headers":{
              "apns-priority": "10"
            }
          },
          "webpush": {
            "headers": {
              "Urgency": "high"
            }
          }
        }
        puts "************************#{android_options.inspect}***********************"
        puts "************************#{android_registration_ids.inspect}***********************"
        android_resp = fcm.send(android_registration_ids, android_options)
      end
      if ios_registration_ids.count > 0
        ios_options = {
          "data": {
            "notification_id": notification.id,
            "meal_id": notification.try(:meal_id),
            "workout_id": notification.try(:workout_id),
            "from_user": notification.try(:user).try(:full_name),
            "to_user": notification.try(:to_user).try(:full_name),
            "notification_type": notification.notification_type,
            "notification_text": format(notification.notification_text, trainer_name: notification_params[:trainer_name], client_name: notification_params[:client_name], task_name: notification_params[:task_name], n: notification_params[:n], day: notification_params[:day], option: notification_params[:option], new_weight: notification_params[:new_weight]),
            "client_id": !notification.to_user.trainer? ? notification.to_user_id : notification.user_id
          },
          "notification": {
            "title": "#{notification.user.full_name.capitalize()}",
            "body": "#{format(notification.notification_text, client_name: notification_params[:client_name], task_name: notification_params[:task_name], n: notification_params[:n], trainer_name: notification_params[:trainer_name], day: notification_params[:day], option: notification_params[:option], new_weight: notification_params[:new_weight])}",
            "sound": "default",
            "badge": Notification.where(to_user_id: notification.to_user_id, status: 'unread').count
          },
          "android":{
            "priority": "high"
          },
          "priority": 10,
          "apns":{
            "headers":{
              "apns-priority": "10"
            }
          },
          "webpush": {
            "headers": {
              "Urgency": "high"
            }
          }
        }
        ios_resp = fcm.send(ios_registration_ids, ios_options)
      end
    end
  end
end