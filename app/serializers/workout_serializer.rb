class WorkoutSerializer
  include FastJsonapi::ObjectSerializer
  include AvatarHelper
  attributes :title, :description, :workout_duration, :calories_burned, :workout_category_id, :done, :date, :video_url, :video_thumbnail, :upload_status

  attribute :workout_category do |object|
    AMS::WorkoutCategorySerializer.new(object.workout_category)
  end

  attribute :image_url do |object|
    avatar_url(object.image)
  end
end
