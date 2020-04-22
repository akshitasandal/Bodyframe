class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.2]
  def change    
    ## Required
    add_column :users, :provider, :string, :null => false, :default => "email"
    add_column :users, :uid, :string, :null => false, :default => ""

    ## Recoverable    
    add_column :users, :allow_password_change, :boolean, :default => false

    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

    add_column :users, :sign_in_count, :integer, :default => 0
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

    ## Tokens
    add_column :users, :tokens, :json    

    remove_index :users, :email
    User.find_each do |user|
      if user.uid.blank?
        user.uid = user.email
        user.provider = 'email'
        user.save!
      end
    end
    add_index :users, [:uid, :provider],     unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,       unique: true
  end
end
