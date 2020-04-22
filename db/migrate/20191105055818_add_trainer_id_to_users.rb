class AddTrainerIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :trainer_id, :integer
  end
end
