# Trestle.resource(:revenue_reporting, model: User) do   

#   # menu do
#   #   item :revenue_reporting, icon: "fa fa-file"
#   # end
  
#   scopes do
#     scope :total_members, -> { User.all}, default: true
#     scope :member_this_month, -> { User.where("users.created_at > ? AND users.created_at < ?", Time.now.beginning_of_month, Time.now.end_of_month) }
#   end

  
#   table do
#     column :email, link: true
#     column :full_name
#     column :objective
#     column :phone
#     column :user_type
#     column :created_at, align: :center
#   end

#   form do |user|
#     row do
#       col(xs: 6) { text_field :email }
#       col(xs: 6) { text_field :full_name }
#     end
#     row do
#       col(xs: 6) { date_field :dob }
#       col(xs: 6) { text_field :address }
#     end
#     row do
#       col(xs: 6) { text_field :phone }
#       col(sm: 6) { select :sex, ['male', 'female'] }
#     end
#     row do
#       col(xs: 6) { select :user_type, ['client', 'trainer'] }
#       col(sm: 6) { text_field :zipcode }
#     end
#     row do
#       col(xs: 6) { text_field :weight }
#       col(sm: 6) { text_field :height }
#     end
#     row do
#       col(xs: 6) { text_field :objective }
#       col(sm: 6) { text_field :state }
#     end
#     row do
#       col(xs: 6) { text_field :city }
#       col(xs: 6) { file_field :avatar }
#     end
#     row do
#       col(xs: 6) { text_field :password }
#       col(xs: 6) { text_field :password_confirmation }
#     end
#   end
  
#   controller do
#     def index
#       @csv = true
#       @dont_display_new_link = true
#       @count = User.count
#     end

#     def show
#       @dont_display_new_link = true
#     end

#     def new
#       head :no_content
#     end
#   end
# end
    