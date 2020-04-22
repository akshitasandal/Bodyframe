Trestle.resource(:users) do
  menu do
    item :users, icon: "fa fa-users"
  end
  scope :trainers, -> { User.where(trainer_id: nil) }
  scope :clients, -> { User.where.not(trainer_id: nil) }
  scope :cancelled_accounts, -> { User.where(status: false) }

  search do |query|
    if query
      User.where("email ILIKE ? OR full_name ILIKE ?", "%#{query}%", "%#{query}%")
    else
      User.all
    end
  end
  #Customize the table columns shown on the index view.
  
  table do
    column :email
    column :full_name
    column :objective
    column :phone
    column :user_type
    column :created_at
    column :cancelled_at
    actions do |toolbar, instance, admin|
      toolbar.edit if admin && admin.actions.include?(:edit)
      toolbar.delete if admin && admin.actions.include?(:destroy)
      # toolbar.link 'Meals', '/admin/meals', action: 'index', method: :get, style: :primary, icon: "fa fa-cutlery"
      toolbar.link 'Launch', instance, action: :launch, method: :get, style: :primary, icon: "fa fa-cutlery"
      toolbar.link 'Workout', instance, action: :workout, method: :get, style: :primary, icon: "fa fa-road"
    end
  end

  controller do
    def launch
      user = admin.find_instance(params)
      user_type = User.where(id: user.id).first.user_type
      if user_type == 'client'
        user.client_meals
      else
        user.trainer_meals
      end
      redirect_to '/admin/meals'
    end

    def workout
      user = admin.find_instance(params)
      user_type = User.where(id: user.id).first.user_type
      if user_type == 'client'
        user.client_workouts
      else
        user.trainer_workouts
      end
      redirect_to '/admin/workouts'
    end
  end

  routes do
    get :launch, on: :member
    get :workout, on: :member
    post :approve, on: :member
    post :decline, on: :member
  end
  # Customize the form fields shown on the new/edit views.

  form do |user|
    row do
      col(xs: 6) { text_field :email }
      col(xs: 6) { text_field :full_name }
    end
    row do
      col(xs: 6) { date_field :dob }
      col(xs: 6) { text_field :address }
    end
    row do
      col(xs: 6) { text_field :phone }
      col(sm: 6) { select :sex, ['male', 'female'] }
    end
    row do
      col(xs: 6) { select :user_type, ['client', 'trainer'] }
      col(sm: 6) { text_field :zipcode }
    end
    row do
      col(xs: 6) { text_field :weight }
      col(sm: 6) { text_field :height }
    end
    row do
      col(xs: 6) { text_field :objective }
      col(sm: 6) { text_field :state }
    end
    row do
      col(xs: 6) { text_field :city }
      col(xs: 6) { file_field :avatar }
    end
    row do
      col(xs: 6) { text_field :password }
      col(xs: 6) { text_field :password_confirmation }
    end
  end
  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:user).permit(:name, ...)
  # end
end
