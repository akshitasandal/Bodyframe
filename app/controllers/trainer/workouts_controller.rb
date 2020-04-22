class Trainer::WorkoutsController < TrainerController
  before_action :set_workout

  swagger_path '/trainer/workouts/{id}' do
    operation :get do
      key :description, 'Trainer Workout Details API'
      key :tags, [
        'Trainer Assigning Client Workouts'
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
        key :description, 'Trainer Workout Details Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def show
    if @workout.present?
      render json: WorkoutSerializer.new(@workout)
    else
      render json: { errors: ["Record not found or might already be deleted."] }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer/workouts' do
    operation :post do
      key :description, 'Trainer Workout Create API'
      key :tags, [
        'Trainer Assigning Client Workouts'
      ]

      parameter do
        key :name, :workout
        key :in, :body
        key :description, 'Create Workout task'
        key :required, true
        schema do
          key :'$ref', :Workout
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
        key :description, 'Trainer Workout Create Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def create
    workout = current_user.trainer_workouts.build(workout_params)
    ImageService.attach_image(params[:workout][:image], workout)
    if workout.save
      notification = current_user.notifications.build(notification_type: 8, notification_text: 8, to_user_id: workout.client_id, workout_id: workout.id)
      notification_params = {day: workout.date.strftime('%m/%d/%Y'), task_name: workout.title }
      current_user.send_notifications(notification, notification_params) if notification.save
      render json: WorkoutSerializer.new(workout), status: :created
    else
      render json: { errors: workout.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer/workouts/{id}' do
    operation :patch do
      key :description, 'Trainer Workout Update Task API'
      key :tags, [
        'Trainer Assigning Client Workouts'
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
          key :'$ref', :Workout
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
      response 200 do
        key :description, 'Trainer Workout Update Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def update
    ImageService.attach_image(params[:workout][:image], @workout)
    if @workout.present? && !@workout.done? && @workout.update(workout_params)
      render json: WorkoutSerializer.new(@workout)
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer/workouts/{id}' do
    operation :delete do
      key :description, 'Trainer Workout Delete Task API'
      key :tags, [
        'Trainer Assigning Client Workouts'
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
        key :description, 'Trainer Workout Response'
      end
    end
  end

  def destroy
    if @workout.present? && @workout.destroy
      render json: { success: 'Workout is deleted successfully.' }
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_workout
    @workout = current_user.trainer_workouts.where(id: params[:id]).first
  end

  def workout_params
    params.require(:workout).permit(:title, :description, :workout_duration, :calories_burned, :client_id, :workout_category_id, :date, :video_url, :video_thumbnail)
  end
end
