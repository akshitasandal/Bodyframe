ActiveRecord::Base.connection.execute("TRUNCATE meal_categories")
puts "Seeding Meal Categories"
MealCategory.create!([
  {name: 'Breakfast'},
  {name: 'Lunch'},
  {name: 'Dinner'},
  {name: 'Snack'},
  {name: 'Pre-Workout'},
  {name: 'Post-Workout'},
])