class ClientSerializer
  include FastJsonapi::ObjectSerializer
  include DateRangeHelper
  include AvatarHelper
  attributes :email, :full_name, :address, :phone, :sex, :weight, :height, :objective, :qb_id, :chat_id, :subscription

  attribute :dob do |object|
    date_of_birth(object.dob)
  end

  attribute :avatar_url do |object|
    avatar_url(object.avatar)
  end

  # attribute :workouts do |record, params|
  #   record.client_workouts.where(date: fetch_date(params[:date])).map do |workout|
  #     AMS::WorkoutSerializer.new(workout)
  #   end
  # end

  attribute :workout_categories do |record, params|
    record.workout_categories.group('workout_categories.id, workout_categories.name').map do |workout_category|
      {
        id: workout_category.id,
        name: workout_category.name,
        workouts: workout_category.workouts.where(date: fetch_date(params[:date]), client_id: record.id).map do |workout|
          AMS::WorkoutSerializer.new(workout)
        end
      }
    end.compact.select {|h| h[:workouts].present? }.to_a
  end

  # attribute :meals do |record, params|
  #   record.client_meals.where(meal_time: fetch_date_range(params[:date])).map do |meal|
  #     AMS::MealSerializer.new(meal)
  #   end
  # end

  attribute :meal_categories do |record, params|
    record.meal_categories.group('meal_categories.id, meal_categories.name').map do |meal_category|
      {
        id: meal_category.id,
        name: meal_category.name,
        meals: meal_category.meals.where(meal_time: fetch_date_range(params[:date]), client_id: record.id).map do |meal|
          AMS::MealSerializer.new(meal)
        end
      }
    end.compact.select {|h| h[:meals].present? }.to_a
  end
end
