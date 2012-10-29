class ChangeAmountColumnLength < ActiveRecord::Migration
  def up
  	change_column :expenses, :amount, :float, :precision => 6, :scale => 2
  end

  def down
  	change_column :expenses, :amount, :float, :precision => 5, :scale => 2
  end
end
