class AMS::CustomMealCategorySerializer < AmsSerializer
    attributes :id, :name
    has_many :meals, class_name: "Meal", serializer: AMS::MealSerializer
  
    def id
      @id ||= object[:id].to_s
    end
  end
  