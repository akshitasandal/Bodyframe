class WorkoutCategoriesController < ApplicationController
  before_action :set_workout_category
  include Swagger::Blocks

  swagger_path '/workout_categories' do
    operation :get  do
      key :description, 'Workout Categories Listing API'
      key :tags, [
        'WorkoutCategory'
      ]
      # definition of success response
      response 200  do
        key :description , 'Workout Categories Listing Response'
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
    end
  end

  def index
    render json: WorkoutCategorySerializer.new(WorkoutCategory.all.order(name: :asc))
  end

  swagger_path '/workout_categories/{id}' do
    operation :get  do
      key :description, 'Workout Category Details API'
      key :tags, [
        'WorkoutCategory'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      # definition of success response
      response 200  do
        key :description , 'Workout Category Details Response'
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
    end
  end

  def show
    render json: WorkoutCategorySerializer.new(@workout_category)
  end

  swagger_path '/workout_categories' do
    operation :post  do
      key :description, 'Workout Category Create API'
      key :tags, [
        'WorkoutCategory'
      ]
      parameter do
        key :name, :WorkoutCategory
        key :in, :body
        key :description, 'Create Workout Category'
        key :required, true
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
      # definition of success response
      response 201  do
        key :description , 'Workout Category Details Response'
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
    end
  end

  def create
    workout_category = Workout.new(category_params)
    if workout_category.save
      render json: WorkoutCategorySerializer.new(workout_category), status: :created
    else
      render json: { errors: workout_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/workout_categories' do
    operation :patch  do
      key :description, 'Workout Category Update API'
      key :tags, [
        'WorkoutCategory'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, :WorkoutCategory
        key :in, :body
        key :description, 'Update Workout Category'
        key :required, true
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
      # definition of success response
      response 201  do
        key :description , 'Workout Category Details Response'
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
    end
  end

  def update
    if @workout_category.present? && @workout_category.update(category_params)
      render json: WorkoutCategorySerializer.new(@workout_category), status: :ok
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  swagger_path '/workout_categories/{id}' do
    operation :delete  do
      key :description, 'Workout Category Delete API'
      key :tags, [
        'WorkoutCategory'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      # definition of success response
      response 200  do
        key :description , 'Workout Category Details Response'
        schema do
          key :'$ref', :WorkoutCategory
        end
      end
    end
  end

  def destroy
    if @workout_category.present? && @workout_category.destroy
      render json: { success: 'Workout Category has beem deleted successfully.' }
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_workout_category
    @workout_category = WorkoutCategory.where(id: params[:id]).first
  end

  def category_params
      params.require(:workout_category).permit(:name)
  end
end
