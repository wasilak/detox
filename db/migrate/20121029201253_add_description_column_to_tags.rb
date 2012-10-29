class AddDescriptionColumnToTags < ActiveRecord::Migration
  def up
  	add_column :tags, :description, :text
  end

  def down
  	remove_column :tags, :description
  end
end
