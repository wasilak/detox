class CreateTableBudgets < ActiveRecord::Migration
    def change
        create_table :budgets do |t|
            t.integer :userId
            t.string :description
            t.float :amount
            t.date :dateStart
            t.date :dateEnd

            t.timestamps
        end
    end

  def down
  end
end
