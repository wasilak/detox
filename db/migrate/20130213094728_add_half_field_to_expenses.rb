class AddHalfFieldToExpenses < ActiveRecord::Migration
  def self.up
    add_column :expenses, :half, :integer, :null => true, :default => 0
  end
  def self.down
    remove_column :expenses, :half
  end
end
