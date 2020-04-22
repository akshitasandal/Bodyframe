class Trainer::MealsController < TrainerController
  before_action :set_meal

  swagger_path '/trainer/meals/{id}' do
    operation :get do
      key :description, 'Trainer Meal Details API'
      key :tags, [
        'Trainer Assigning Client Meals'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end      
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end

      # definition of success response
      response 200 do
        key :description, 'Meal Details Response'
        schema do
          key :'$ref', :Meal
        end
      end
    end
  end

  def show
    if @meal.present?
      render json: MealSerializer.new(@meal), status: :ok
    else
      render json: { errors: ["Record not found or might already be deleted."] }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer/meals' do
    operation :post do
      key :description, 'Trainer Meal Create API'
      key :tags, [
        'Trainer Assigning Client Meals'
      ]
      parameter do
        key :name, :meal
        key :in, :body
        key :description, 'Create Meal task'
        key :required, true
        schema do
          key :'$ref', :Meal
        end
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end

      # definition of success response
      response 201 do
        key :description, 'Create Meal Response'
        schema do
          key :'$ref', :Meal
        end
      end
    end
  end

  def create
    meal = current_user.trainer_meals.build(meal_params)
    ImageService.attach_image(params[:meal][:image], meal)
    if meal.valid? and meal.save
      notification = current_user.notifications.build(notification_type: 9, notification_text: 9, to_user_id: meal.client_id, meal_id: meal.id)
      notification_params = { day: meal.meal_time.strftime('%m/%d/%Y'), task_name: meal.title }
      current_user.send_notifications(notification, notification_params) if notification.save
      render json: MealSerializer.new(meal), status: :created
    else
      render json: { errors: meal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer/meals/{id}' do
    operation :patch do
      key :description, 'Trainer Meal Update API'
      key :tags, [
        'Trainer Assigning Client Meals'
      ]
      parameter do
        key :name, :meal
        key :in, :body
        key :description, 'Update Meal task'
        key :required, true
        schema do
          key :'$ref', :Meal
        end
      end
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end

      # definition of success response
      response 200 do
        key :description, 'Update Meal Response'
        schema do
          key :'$ref', :Meal
        end
      end
    end
  end

  def update
    ImageService.attach_image(params[:meal][:image], @meal)
    if @meal.present? && !@meal.done? && @meal.update(meal_params)
      render json: MealSerializer.new(@meal), status: :created
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :created
    end
  end

  swagger_path '/trainer/meals/{id}' do
    operation :delete do
      key :description, 'Trainer Meal destroy API'
      key :tags, [
        'Trainer Assigning Client Meals'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end

      # definition of success response
      response 200 do
        key :description, 'Response'
      end
    end
  end

  def destroy
    if @meal.present? && @meal.destroy
      render json: { success: 'Meal is deleted successfully.' }
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private
  
  def set_meal
    @meal = current_user.trainer_meals.where(id: params[:id]).first
  end

  def meal_params
    params.require(:meal).permit(:title, :description, :category, :meal_time, :protein, :carbs, :fat, :client_id, :meal_category_id, :calories, :video_url, :video_thumbnail)
  end
end
