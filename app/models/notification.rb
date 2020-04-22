class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :to_user, class_name: "User", foreign_key: :to_user_id
  belongs_to :meal, optional: true
  belongs_to :workout, optional: true

  enum status: ['unread', 'read']
  enum notification_text: ["%{n} number of Clients today","Invite your first client to BodyFrame", "You have a new Client", "You received a Payment!", "%{client_name} completed Workout Task %{task_name}", "%{client_name} completed Meal Task %{task_name}", "%{client_name} did not completed Meal Task %{task_name}", "%{client_name} did not completed Workout Task %{task_name}", "You have a new Workout Task %{task_name} for %{day}", "You have New Meal %{task_name} for %{day}", "You have not completed today's Workout Task %{task_name}, Complete now", "You have not completed today's Meal Task %{task_name}, Complete Now", "You received a Referral Bonus from %{trainer_name}", "Congratulations! You completed today's Meal Task %{task_name}", "Congratulations! You completed today's Workout Task %{task_name}", "%{client_name} has updated their Goal to %{option}", "%{client_name} has changed their weight to %{new_weight}", 'You have a new plan', '%{client_name} has upgraded their  plan']

  enum notification_type: ["invited_client_today", "invite_first_client", "have_new_client", "received_a_payment", "completed_workout", "completed_meal", "not_completed_meal", "not_completed_workout", "new_workout", "new_meal", "client_not_completed_workout", "client_not_completed_meal", "trainer_referral_subscription", "congratulation_meal_completed", "congratulation_workout_completed", "client_updated_goal", "client_changed_weight", "client_have_new_plan", "client_upgraded_plan"]
end