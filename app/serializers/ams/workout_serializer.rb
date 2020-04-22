class AMS::WorkoutSerializer < AmsSerializer
  include AvatarHelper
  attributes :id, :title, :description, :workout_duration, :calories_burned, :done, :date, :workout_category_id, :image_url, :video_url, :video_thumbnail, :upload_status
  
  has_one :workout_category, serializer: AMS::WorkoutCategorySerializer

  def workout_category_id
    @workout_category_id ||= object[:workout_category_id].to_s
  end
end
