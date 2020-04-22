# Trestle.resource(:workouts) do
#     menu do
#       item :workouts, icon: "fa fa-road"
#     end
  
#     #Customize the table columns shown on the index view.
    
#     table do
#       column :title
#       column :workout_category#, link: false
#       column :calories_burned
#       column :client
#       column :workout_duration
#       actions do |toolbar, instance, admin|
#         toolbar.edit if admin && admin.actions.include?(:edit)
#         toolbar.delete if admin && admin.actions.include?(:destroy)
#       end
#     end
    
#     controller do
#       def index
#         @dont_display_new_link = true
#         @count = Workout.count
#       end
#     end
#   end
  