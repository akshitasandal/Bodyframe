class Trainer::ClientsController < TrainerController
  include CustomDateHelper
  before_action :set_client, except: :index

  swagger_path '/trainer/clients?date=' do
    operation :get do
      key :description, 'Fetch Trainer Clients List'
      key :tags, [
        'Trainer Clients'
      ]
      parameter do
        key :name, :date
        key :in, :query
        key :required, false
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
        key :description , 'Client Listings Response'
        schema do
          key :'$ref', :UserRegister
        end
      end
    end
  end

  def index
    clients = trainer_clients.includes(:client_workouts, :client_meals)
    clients = clients.where(workouts: { date: fetch_date(params[:date])})
    .or(trainer_clients.includes(:client_workouts, :client_meals)
    .where(meals: { meal_time: fetch_date_range(params[:date])})) if params[:date].present?
    render json: ClientSerializer.new(clients, { params: permitted_params, meta: { user: AMS::UserSerializer.new(current_user) } })
  end

  swagger_path '/trainer/clients/{id}?date=YYYY-MM-DD' do
    operation :get do
      key :description, 'Get Client Details'
      key :tags, [
        'Trainer Clients'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :required, false
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
        key :description , 'Client Details Response'
        schema do
          key :'$ref', :ClientResponse
        end
      end
    end
  end

  def show
    if @client && @client.status == true
      render json: ClientSerializer.new(@client, { params: permitted_params })
    else
      render json: { errors: ["The client has been deactivated or subscription is expired."] }, status: :unprocessable_entity
    end
  end
  private

  def trainer_clients
    current_user.clients.where(user_type: "client", subscription: "active").active_accounts.order(:id)
  end

  def set_client
    clients =  current_user.clients.where(user_type: "client").order(:id)
    @client = trainer_clients.where(id: params[:id]).first
  end

  def permitted_params
    params.permit!.slice(:date).to_h
  end
end
