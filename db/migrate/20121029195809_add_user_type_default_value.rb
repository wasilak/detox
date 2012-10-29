class AddUserTypeDefaultValue < ActiveRecord::Migration
  def up
  	change_column :users, :type_id, :integer, :null => false, :default => 1
  end

  def down
  	# You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
