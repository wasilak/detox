class RenameExpensesHalfColumn < ActiveRecord::Migration
  def change
    change_column :expenses, :half, :float, :null => false, :default => 0
    rename_column :expenses, :half, :share_percentage
  end
end
