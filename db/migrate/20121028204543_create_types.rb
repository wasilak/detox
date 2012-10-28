class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :typeName

      t.timestamps
    end
    rename_column :users, :userType, :type_id
  end
end
