class WorkoutCategory < ApplicationRecord
  include Swagger::Blocks
  has_many :workouts
  has_many :client_workouts, class_name: "Workout"
  swagger_schema :WorkoutCategory do
    key :required, [:name]
    property :workout_category do
      property :name do
        key :type, :string
      end
    end
  end
end
