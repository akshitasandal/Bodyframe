Trestle.resource(:all_members, model: User) do   

    # menu do
    #   item :all_members, icon: "fa fa-file"
    # end

    scope :trainers, -> { User.where(trainer_id: nil) }
    scope :clients, -> { User.where.not(trainer_id: nil) }

    table do
      column :email, link: true
      column :full_name
      column :objective
      column :phone
      column :user_type
      column :created_at, align: :center
    end
    
    controller do
      def index
        @csv = true
        @dont_display_new_link = true
        @users = params[:type] == "trainer" ? User.trainer : (params[:type] == "client" ? User.client : User.all)
        @users =  @users.where("full_name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
        if params[:sort].present?
          @users = @users.sort_by{ |h| h[params[:sort].to_sym] }
          if params[:order].eql?('desc')
              @users = @users.reverse
          end
          @users = Kaminari.paginate_array(@users).page(params[:page]).per(20)
        end
        @users
        @count = @users.size
      end

      def payment_history
        if params[:user_id].present?
          @user = User.find(params[:user_id])
          if @user.trainer?
            @payments = @user.payment_histories
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
        @count =  @payments.size
      end

      def all_members_csv
        require 'csv'
        @users = params[:type] == "trainer" ? User.trainer : (params[:type] == "client" ? User.client : User.all)
        respond_to do |format|
          format.html
          format.csv { send_data @users.to_csv1, filename: "members-#{Date.today}.csv" }
        end
      end
  
      def show
        @dont_display_new_link = true
      end
  
      def new
        head :no_content
      end
    end

    routes do
      get :payment_history, on: :collection
      get :all_members_csv, on: :collection, as: :all_members_csv
    end
end
      