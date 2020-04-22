class AMS::CustomWorkoutCategorySerializer < AmsSerializer
    attributes :id, :name
    has_many :workouts, class_name: "Workout", serializer: AMS::WorkoutSerializer
  
    def id
      @id ||= object[:id].to_s
    end
  end
  