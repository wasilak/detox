class AddBudgetFieldToTags < ActiveRecord::Migration
  def change
    add_column :tags, :budget, :boolean
  end
end
