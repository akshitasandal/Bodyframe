class AddTwilioResponseToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :twilio_response, :text, default: ''
  end
end
