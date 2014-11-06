class AddUserIdToQuits < ActiveRecord::Migration
  def change
    add_column :quits, :user_id, :integer
    add_index :quits, :user_id
  end
end
