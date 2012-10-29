class AddUniqueIndex < ActiveRecord::Migration
  def up
  	add_index :expenses_tags_associations, [:expense_id, :tag_id], :unique => true
  end

  def down
  end
end
