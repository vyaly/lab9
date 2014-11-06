class CreateQuits < ActiveRecord::Migration
  def change
    create_table :quits do |t|
      t.text :text

      t.timestamps
    end
  end
end
