class MealCategoriesController < ApplicationController
  before_action :set_meal_category
  include Swagger::Blocks

  swagger_path '/meal_categories' do
    operation :get  do
      key :description, 'Meal Categories Listing API'
      key :tags, [
        'MealCategory'
      ]
      # definition of success response
      response 200  do
        key :description , 'Meal Categories Listing Response'
        schema do
          key :'$ref', :MealCategory
        end
      end
    end
  end

  def index
    render json: MealCategorySerializer.new(MealCategory.all.order(name: :asc))
  end

  swagger_path '/meal_categories/{id}' do
    operation :get  do
      key :description, 'Meal Category Details API'
      key :tags, [
        'MealCategory'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      # definition of success response
      response 200  do
        key :description , 'Meal Category Details Response'
        schema do
          key :'$ref', :MealCategory
        end
      end
    end
  end

  def show
    render json: MealCategorySerializer.new(@meal_category)
  end

  swagger_path '/meal_categories' do
    operation :post  do
      key :description, 'Meal Category Create API'
      key :tags, [
        'MealCategory'
      ]
      parameter do
        key :name, :MealCategory
        key :in, :body
        key :description, 'Create Meal Category'
        key :required, true
        schema do
          key :'$ref', :MealCategory
        end
      end
      # definition of success response
      response 201  do
        key :description , 'Meal Category Details Response'
        schema do
          key :'$ref', :MealCategory
        end
      end
    end
  end
  
  def create
    meal_category = MealCategory.new(category_params)
    if meal_category.save
      render json: MealCategorySerializer.new(meal_category), status: :ok
    else
      render json: { errors: meal_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/meal_categories/{id}' do
    operation :patch  do
      key :description, 'Meal Category Update API'
      key :tags, [
        'MealCategory'
      ]      
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, :MealCategory
        key :in, :body
        key :description, 'Update Meal Category'
        key :required, true
        schema do
          key :'$ref', :MealCategory
        end
      end
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      # definition of success response
      response 201  do
        key :description , 'Meal Category Details Response'
        schema do
          key :'$ref', :MealCategory
        end
      end
    end
  end

  def update
    if @meal_category.present? && @meal_category.update(category_params)
      render json: MealCategorySerializer.new(@meal_category), status: :ok
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  swagger_path '/meal_categories/{id}' do
    operation :delete  do
      key :description, 'Meal Category Delete API'
      key :tags, [
        'MealCategory'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      # definition of success response
      response 200  do
        key :description , 'Meal Category Details Response'
        schema do
          key :'$ref', :MealCategory
        end
      end
    end
  end

  def destroy
    if @meal_category.present? && @meal_category.destroy
      render json: { success: 'Meal Category has been deleted successfully.' }
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_meal_category
    @meal_category = MealCategory.where(id: params[:id]).first
  end

  def category_params
    params.require(:meal_category).permit(:name)
  end
end
