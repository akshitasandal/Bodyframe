class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bank_account
  include Swagger::Blocks

  swagger_path '/bank_accounts' do
    operation :post  do
      key :description, 'Add New Bank Account API'
      key :tags, [
        'Bank Accounts'
      ]
      parameter do
        key :name, :id
        key :in, :body
        key :description, 'Add New Bank Account'
        key :required, true
        schema do
          key :'$ref', :AddBankAccount
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
        key :description , 'New Bank Account response'
        schema do
          key :'$ref', :AddBankAccount
        end
      end
    end
  end

  def create
    bank_account = current_user.bank_accounts.build(bank_account_params)
    if current_user.trainer? and bank_account.save
      render json: BankAccountSerializer.new(bank_account)
      AwsSesMailer.welcome_email(current_user, options = { subject: 'New Checking Account Added'}).deliver_now
    else
      render json: { errors: bank_account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/bank_accounts/{id}' do
    operation :delete  do
      key :description, 'Delete Bank Account API'
      key :tags, [
        'Bank Accounts'
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
        key :description , 'Delete Bank Account response'
        schema do
          key :'$ref', ''
        end
      end
    end
  end

  def destroy
    if current_user.trainer? and @bank_account.present? and @bank_account.destroy
      render json: { success: 'Bank Account has been deleted successfully.' }
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  private

  def set_bank_account
    @bank_account = current_user.bank_accounts.where(id: params[:id]).first
  end

  def bank_account_params
    params.require(:bank_account).permit(:name, :bank_name, :routing_number, :account_number, :source_id)
  end
end
