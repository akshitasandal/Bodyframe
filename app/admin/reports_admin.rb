Trestle.resource(:reports, model: User) do   

    # menu do
    #   item :new_trainer_sign_ups, icon: "fa fa-file"
    # end

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
        @trainers = User.trainer
        @trainers = @trainers.where("email ILIKE ? OR full_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")
        if params[:from_date].present? && params[:to_date].present? && params[:from_date] == params[:to_date]
          @trainers = @trainers.where('created_at >= ?', params[:from_date])
        elsif params[:from_date].present? && params[:to_date].present?
          @trainers = @trainers.where('created_at >= ?', params[:from_date]).where('created_at <= ?', params[:to_date])
				elsif params[:from_date].present? && !params[:to_date].present?
          @trainers = @trainers.where('created_at >= ?', params[:from_date])
				elsif params[:to_date].present? && !params[:from_date].present?
          @trainers = @trainers.where('created_at <= ?', params[:to_date])
        else
          @trainers
        end
       @count = @trainers.count
      end

      def trainers
				@trainer = User.trainer
      end
  
      def show
        @dont_display_new_link = true
      end
  
      def new
        head :no_content
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
          if params[:from_date].present? && params[:to_date].present?
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

      def new_trainers_csv
        require 'csv'
        @trainers = User.trainer
        @trainers = @trainers.where("email ILIKE ? OR full_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
        if params[:from_date].present? && params[:to_date].present?
          @trainers = @trainers.where('created_at >= ?', params[:from_date]).where('created_at <= ?', params[:to_date])
        elsif params[:from_date].present? && !params[:to_date].present?
          @trainers = @trainers.where('created_at >= ?', params[:from_date])
        elsif params[:to_date].present? && !params[:from_date].present?
          @trainers = @trainers.where('created_at <= ?', params[:to_date])
        else
          @trainers
        end
        respond_to do |format|
          format.html
          
          format.csv { send_data @trainers.to_csv, filename: "trainers-#{Date.today}.csv" }
        end
      end
      private

      def to_csv
        attributes = ["id", "full_name", "email", "phone", "user_type"]
        CSV.generate(headers: true) do |csv|
          csv << attributes
          User.all.each do |user|
            csv << attributes.map{ |attr| user.send(attr) }
          end
        end
      end
    
    end
    routes do
      get :trainers, on: :collection
      get :payment_history, on: :collection
      get :new_trainers_csv, on: :collection, as: :new_trainers_csv
    end
end
      