class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :name
      t.integer :userType

      t.timestamps
    end
  end
end