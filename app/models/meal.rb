class Meal < ApplicationRecord
  include Swagger::Blocks
  include ActiveStorageSupport::SupportForBase64
  has_one_base64_attached :avatar

  belongs_to :user
  belongs_to :client, class_name: "User", foreign_key: :client_id
  belongs_to :meal_category
  has_one_base64_attached :image

  has_many :notifications, dependent: :destroy

  validates :title, :meal_category_id, :client_id, presence: true

  scope :ordered, -> { order(:meal_time) }

  swagger_schema :Meal do
    key :required, [:title, :meal_category_id]
    property :meal do
      property :title do
        key :type, :string
      end
      property :description do
        key :type, :string
      end
      property :meal_category_id do
        key :type, :integer
      end
      property :meal_time do
        key :type, :string
        key :format, :date
      end
      property :calories do
        key :type, :integer
      end
      property :protein do
        key :type, :integer
      end
      property :carbs do
        key :type, :integer
      end
      property :fat do
        key :type, :integer
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

  swagger_schema :ClientMeal do
    key :required, [:done]
    property :meal do
      property :done do
        key :type, :boolean
      end
    end
  end  
end
