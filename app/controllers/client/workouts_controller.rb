class Client::WorkoutsController < ClientController
  before_action :set_workout

  swagger_path '/client/workouts/{id}' do
    operation :get  do
      key :description, 'Client Workout Details API'
      key :tags, [
        'Client Workouts'
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
      response 200  do
        key :description , 'Client Workout Details Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def show
    if @workout.present?
      render json: WorkoutSerializer.new(@workout), status: :ok
    else
      render json: { errors: ["Record not found or might already be deleted."] }, status: :unprocessable_entity
    end
  end

  swagger_path '/client/workouts/{id}' do
    operation :patch do
      key :description, 'Client Workout MARK as DONE/NOT-DONE'
      key :tags, [
        'Client Workouts'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, :workout
        key :in, :body
        key :description, 'Update Workout task'
        key :required, true
        schema do
          key :'$ref', :ClientWorkout
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
      response 200  do
        key :description , 'Client Workout Update Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def update
    if @workout.present? && !@workout.done? && @workout.update(workout_params)
      notification = current_user.notifications.build(notification_type: 4, notification_text: 4, to_user_id: current_user.trainer.id, workout_id: @workout.id)
      notification_params = { client_name: current_user.full_name , task_name: @workout.title}
      current_user.send_notifications(notification, notification_params) if notification.save
      notification1 = current_user.notifications.build(notification_type: 14, notification_text: 14, to_user_id: current_user.id, workout_id: @workout.id)
      current_user.send_notifications(notification1, notification_params) if notification1.save
      render json: WorkoutSerializer.new(@workout)
    elsif @workout.present? && @workout.done?
      render json: { errors: ['Task has already been updated.'] }, status: :unprocessable_entity
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_workout
    @workout = current_user.client_workouts.where(id: params[:id]).first
  end

  def workout_params
    params.require(:workout).permit(:done)
  end
end
