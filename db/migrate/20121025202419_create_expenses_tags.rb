class CreateExpensesTags < ActiveRecord::Migration
  def change
    create_table :expenses_tags do |t|
      t.integer :expenseId
      t.integer :tagId

      t.timestamps
    end
  end
end
