class Trainer::InvitationsController < TrainerController
  swagger_path '/trainer/invitations' do
    operation :post do
      key :description, 'Trainer Client Invitation Create API'
      key :tags, [
        'Trainer Client Invitations API'
      ]
      parameter do
        key :name, :invitation
        key :in, :body
        key :description, 'Create Client Invitation'
        key :required, true
        schema do
          key :'$ref', :Invitation
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
        key :description, 'Create Invitations Response'
        schema do
          key :'$ref', :Invitation
        end
      end
    end
  end

  def create
    invitation = current_user.trainer_invites.build(invitation_params)
    if invitation.valid? and invitation.save
      begin
        user = User.find_by(email: invitation_params[:email])
        if user && user.status? 
          invitation.destroy
          render json: { errors: ["Email has already been taken by a user. Please try inviting a user with different email."] }, status: :unprocessable_entity
        elsif user && !user.status? && user.user_type == "client"
          invitation.generate_plan_invite(invitation_params[:phone])
          current_user.upgrade_requests.where(client_id: user.id, status: "requested").update(status: "expired")
          current_user.upgrade_requests.create(client_id: user.id, monthly_amount: invitation.monthly_amount, session_amount: invitation.session_amount, session_count: invitation.session_count, per_session_amount: invitation.per_session_amount)
          user.update(status: true)
          render json: { success: 'Invitation has been sent via SMS successfully' }, status: :created
        else
          invitation_params[:user_type] == "client" ? invitation.generate_client_invite(invitation_params[:phone]) : invitation.generate_trainer_invite(invitation_params[:phone])
          render json: { success: 'Invitation has been sent via SMS successfully' }, status: :created
        end
      rescue Twilio::REST::TwilioError => e
        render json: { errors: [e.response.body['message']] }, status: :unprocessable_entity
      end
    else
      render json: { errors: invitation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def invitation_params
    params.require(:invitation).permit(:full_name, :phone, :monthly_amount, :plan, :user_type, :email, :session_count, :session_amount, :per_session_amount)
  end
end