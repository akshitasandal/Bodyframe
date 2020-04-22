class Client::MealsController < ClientController
  before_action :set_meal

  swagger_path '/client/meals/{id}' do
    operation :get do
      key :description, 'Fetch Client Meal Details API'
      key :tags, [
        'Client Meals'
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
        key :description , 'Meal Details Response'
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

  swagger_path '/client/meals/{id}' do
    operation :patch do
      key :description, 'Client Meal MARK as DONE/NOT-DONE'
      key :tags, [
        'Client Meals'
      ]
      parameter do
        key :name, :meal
        key :in, :body
        key :description, 'Update Meal task'
        key :required, true
        schema do
          key :'$ref', :ClientMeal
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
        key :description , 'Update Meal Response'
        schema do
          key :'$ref', :ClientMeal
        end
      end
    end
  end

  def update
    if @meal.present? && !@meal.done? && @meal.update(meal_params)
      notification = current_user.notifications.build(notification_type: 5, notification_text: 5, to_user_id: current_user.trainer.id, meal_id: @meal.id)
      notification_params = { client_name: current_user.full_name , task_name: @meal.title}
      current_user.send_notifications(notification, notification_params) if notification.save
      notification1 = current_user.notifications.build(notification_type: 13, notification_text: 13, to_user_id: current_user.id, meal_id: @meal.id)
      current_user.send_notifications(notification1, notification_params) if notification1.save
      render json: MealSerializer.new(@meal)
    elsif @meal.present? && @meal.done?
      render json: { errors: ['Task has already been updated.'] }, status: :unprocessable_entity
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_meal
    @meal = current_user.client_meals.where(id: params[:id]).first
  end

  def meal_params
    params.require(:meal).permit(:done)
  end
end
