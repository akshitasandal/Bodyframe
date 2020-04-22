class Web::PaymentHistoriesController < ActionController::Base
    def index
        require 'csv'
        if params[:user_id].present?
            @user = User.find(params[:user_id])
            if @user.trainer?
              @payments = @user.payment_histories.where(client_id: nil)
              if params[:type] == "paid"
                @payments = @payments.where(reward_total: nil)
              elsif params[:type] == "earned"
                @payments = @payments.where.not(reward_total: nil)
              end
            else
              @payments = PaymentHistory.where(client_id: @user.id)
            end
            @payments =  @payments.includes(:user).where("users.email ILIKE ? OR users.full_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
            if params[:from_date].present? && params[:to_date].present? && params[:from_date] == params[:to_date]
              @payments = @payments.where('created_at >= ?', params[:from_date])
            elsif params[:from_date].present? && params[:to_date].present?
               @payments =  @payments.where('created_at >= ?', params[:from_date]).where('created_at <= ?', params[:to_date])
            elsif params[:from_date].present? && !params[:to_date].present?
               @payments =  @payments.where('created_at >= ?', params[:from_date])
            elsif params[:to_date].present? && !params[:from_date].present?
               @payments =  @payments.where('created_at <= ?', params[:to_date])
            else
               @payments
            end
        end
        respond_to do |format|
            format.html
            format.csv { send_data @payments.to_csv_p, filename: "payment-#{Date.today}.csv" }
        end
    end
end
