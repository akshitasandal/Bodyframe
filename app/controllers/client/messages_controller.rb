class Client::MessagesController < ClientController
  before_action :token_authenticate_user!

  def index
  
  end
end
