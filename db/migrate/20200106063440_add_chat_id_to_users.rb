class AddChatIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :chat_id, :string, default: ''
  end
end
