class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title , 'BodyFrame API'
      key :description , 'CRUD API for BodyFrame Project'
      contact do
        key :name , 'https://github.com/erendira'
      end
    end
    key :schemes, ['https', 'http']
    key :host , ENV['BASE_URL']
    key :basePath , '/'
    key :consumes , ['application/json']
    key :produces , ['application/json']
    tag do
      key :name, 'User'
    end
  end

  # A list of all classes that have swagger_ * declarations.
  SWAGGERED_CLASSES = [
    Trainer::ClientsController,
    Trainer::MessagesController,
    Trainer::NotificationsController,
    Trainer::MealsController,
    Trainer::WorkoutsController,
    Trainer::InvitationsController,
    Trainer::UpgradeRequestsController,
    ClientController,
    Client::MessagesController,
    Client::NotificationsController,
    Client::MealsController,
    Client::WorkoutsController,
    WorkoutCategoriesController,
    MealCategoriesController,
    UsersController,
    CreditCardsController,
    BankAccountsController,
    DeviceTokensController,
    Devise::SessionsController,
    Devise::RegistrationsController,
    Devise::PasswordsController,
    User,
    Client,
    Workout,
    Meal,
    WorkoutCategory,
    MealCategory,
    Invitation,
    CreditCard,
    BankAccount,
    UpgradeRequest,
    DeviceToken,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
