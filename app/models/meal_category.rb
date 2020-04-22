class MealCategory < ApplicationRecord
  include Swagger::Blocks
  has_many :meals
  has_many :client_meals, class_name: "Meal"
  swagger_schema :MealCategory do
      key :required, [:name]
      property :meal_category do
        property :name do
          key :type, :string
        end
      end
    end
end
