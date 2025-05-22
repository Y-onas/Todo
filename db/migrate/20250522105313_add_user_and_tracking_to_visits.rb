class AddUserAndTrackingToVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :visits, :user_id, :integer, null: true
    add_column :visits, :ip_address, :string
    add_column :visits, :user_agent, :string
  end
end
