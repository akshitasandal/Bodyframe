class MealSerializer
  include FastJsonapi::ObjectSerializer
  include AvatarHelper
  attributes :title, :description, :protein, :carbs, :fat, :meal_category_id, :done, :calories, :video_url, :video_thumbnail, :upload_status

  attribute :meal_time do |object|
    object.meal_time.present? ? object.meal_time.utc : ''
  end

  attribute :meal_date do |object|
    object.meal_time.present? ? object.meal_time.to_date.to_s : ''
  end

  attribute :meal_category do |object|
    AMS::MealCategorySerializer.new(object.meal_category)
  end

  attribute :image_url do |object|
    avatar_url(object.image)
  end
end
