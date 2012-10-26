class CreateExpensesTagsAssociations < ActiveRecord::Migration
  def change
    create_table :expenses_tags_associations do |t|
      t.integer :expense_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
