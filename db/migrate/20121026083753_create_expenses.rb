class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :userId
      t.string :description
      t.float :amount
      t.date :date

      t.timestamps
    end
  end
end
