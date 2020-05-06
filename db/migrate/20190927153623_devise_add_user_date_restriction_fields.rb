class DeviseAddUserDateRestrictionFields < ActiveRecord::Migration
 def change
  add_column :users, :valid_from, :date
  add_column :users, :valid_until, :date
 end
end
