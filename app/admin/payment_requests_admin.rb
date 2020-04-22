Trestle.resource(:admin_payouts) do
  menu do
    item :trainer_payouts, icon: "fa fa-money"
  end
  scopes do
    scope :all, -> { AdminPayout.all }, default: true
    scope :pending, -> { AdminPayout.where(payment: 1) }
    scope :approved, -> { AdminPayout.where(payment: 2) }
    scope :declined, -> { AdminPayout.where(payment: 3) }
  end
  # table do
  #   column :email, ->(admin_payout) { admin_payout.user.email }
  #   column :full_name, ->(admin_payout) { admin_payout.user.full_name }, link: false
  #   column :phone, ->(admin_payout) { admin_payout.user.phone }, link: false
  #   column :amount_requested, ->(admin_payout) { sprintf("$%2.2f", admin_payout.amount_requested) }, link: false
  #   column :status, ->(admin_payout) { admin_payout.payment == "requested" ? "pending" : admin_payout.payment }, link: false
  #   actions do |toolbar, instance, admin|
  #     toolbar.link 'Trainer', instance, action: :trainer_info, method: :get, style: :primary
  #     toolbar.link 'Payments', instance, action: :payment_info, method: :get, style: :primary
  #     toolbar.link 'Bank Info', instance, action: :bank_info, method: :get, style: :primary
  #     if instance.requested?
  #       toolbar.link 'Approve', instance, action: :approve, method: :post, style: :primary
  #     elsif instance.approved?
  #       toolbar.link 'Approved', instance, action: :approve, method: :post, style: :primary, class: "green-btn"
  #     end
  #   end
  # end

  controller do
    def index
      @dont_display_new_link = true
      @count = AdminPayout.count
      @payouts = AdminPayout.all
      if params[:type] == "pending"
        @payouts = @payouts.where(payment: 1)
      elsif params[:type] == "approved"
        @payouts = @payouts.where(payment: 2)
      elsif params[:type] == "declined"
        @payouts = @payouts.where(payment: 3)
      else
        @payouts = @payouts
      end
      @payouts = @payouts.includes(:user).where("users.email ILIKE ? OR users.full_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
      if params[:from_date].present? && params[:to_date].present? && params[:from_date] == params[:to_date]
        @payouts = @payouts.where('created_at >= ?', params[:from_date])
      elsif params[:from_date].present? && params[:to_date].present?
        @payouts = @payouts.where('created_at >= ?', params[:from_date]).where('created_at <= ?', params[:to_date])
      elsif params[:from_date].present? && !params[:to_date].present?
        @payouts = @payouts.where('created_at >= ?', params[:from_date])
      elsif params[:to_date].present? && !params[:from_date].present?
        @payouts = @payouts.where('created_at <= ?', params[:to_date])
      else
        @payouts
      end
    end

    def show
      @dont_display_new_link = true
    end
    
    def trainer_info
      admin_payout = admin.find_instance(params)
      @trainer = admin_payout.user
    end
    
    def payment_info
      admin_payout = admin.find_instance(params)
      @payments = admin_payout.payment_histories
      @count =  @payments.count
    end

    def bank_info
      admin_payout = admin.find_instance(params)
      @bank_accounts = admin_payout.user.bank_accounts
      @count = @bank_accounts.count
    end
  end

  routes do
    get :payment_info, on: :member
    get :trainer_info, on: :member
    get :bank_info, on: :member
  end
end
  