class AddSlackIdToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :slack_id, :string
  end
end
