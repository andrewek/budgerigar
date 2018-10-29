class CreateAllocations < ActiveRecord::Migration[5.2]
  def change
    create_table :allocations do |t|
      t.integer :amount
      t.integer :category_id

      t.timestamps
      t.index :category_id
    end
  end
end
