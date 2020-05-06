class CreateInsints < ActiveRecord::Migration[5.0]
  def change
    create_table :insints do |t|
      t.string :subdomen
      t.string :password
      t.integer :insalesid
      t.integer :user_id

      t.timestamps
    end
  end
end
