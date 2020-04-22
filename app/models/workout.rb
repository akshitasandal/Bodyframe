class Workout < ApplicationRecord
  include Swagger::Blocks
  include ActiveStorageSupport::SupportForBase64
  
  has_one_base64_attached :avatar

  belongs_to :user
  belongs_to :client, class_name: "User", foreign_key: :client_id
  belongs_to :workout_category
  has_one_base64_attached :image

  has_many :notifications, dependent: :destroy

  validates :title, :workout_category_id, :client_id, presence: true

  swagger_schema :Workout do
    key :required, [:title, :workout_category_id]
    property :workout do
      property :title do
        key :type, :string
      end
      property :date do
        key :type, :string
      end
      property :description do
        key :type, :string
      end
      property :workout_category_id do
        key :type, :integer
      end
      property :workout_duration do
        key :type, :integer
      end
      property :calories_burned do
        key :type, :string
      end
      property :image do
        key :type, :string
      end
      property :video_url do
        key :type, :string
      end
      property :video_thumbnail do
        key :type, :string
      end
      property :client_id do
        key :type, :integer
      end
    end
  end

  swagger_schema :ClientWorkout do
    key :required, [:done]
    property :workout do
      property :done do
        key :type, :boolean
      end
    end
  end
end
