class AMS::MealSerializer < AmsSerializer
  include AvatarHelper

  attributes :id, :title, :description, :protein, :carbs, :fat, :done, :meal_category_id, :calories, :image_url, :video_url, :video_thumbnail, :upload_status
  
  attribute :meal_time do
    object.meal_time.present? ? object.meal_time.utc : ''
  end

  attribute :meal_date do
    object.meal_time.present? ? object.meal_time.to_date.to_s : ''
  end

  # has_one :meal_category, serializer: AMS::MealCategorySerializer

  def meal_category_id
    @meal_category_id ||= object[:meal_category_id].to_s
  end
end
