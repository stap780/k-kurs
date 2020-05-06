class AddColumnStatusToInsints < ActiveRecord::Migration[5.0]
  def change
    add_column :insints, :status, :boolean
  end
end
