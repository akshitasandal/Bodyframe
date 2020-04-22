ActiveRecord::Base.connection.execute("TRUNCATE workout_categories")
puts "Seeding Workout Categories"
WorkoutCategory.create!([
  {name: 'legs'},
  {name: 'back'},
  {name: 'chest'},
  {name: 'cardio'},
  {name: 'full body'},
  {name: 'intervals'},
])