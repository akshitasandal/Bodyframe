# Trestle.resource(:meals) do
#   menu do
#     item :meals, icon: "fa fa-cutlery"
#   end

#   #Customize the table columns shown on the index view.
  
#   table do
#     column :title
#     column :meal_category#, link: false
#     column :protein
#     column :carbs
#     column :fat
#     column :client
#     column :meal_time, align: :center
#     actions do |toolbar, instance, admin|
#       toolbar.edit if admin && admin.actions.include?(:edit)
#       toolbar.delete if admin && admin.actions.include?(:destroy)
#     end
#   end

#   controller do
#     def index
#       @dont_display_new_link = true
#       @count = Meal.all.size
#     end
#   end
  
# end
  